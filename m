Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1ASWVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:21:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54546
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754459Ab1ASWVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:21:30 -0500
Date: Wed, 19 Jan 2011 14:22:04 -0800 (PST)
Message-Id: <20110119.142204.124077863.davem@davemloft.net>
To: mathieu.desnoyers@efficios.com
Cc: rostedt@goodmis.org, richm@oldelvet.org.uk, 609371@bugs.debian.org,
        ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110119221538.GB23544@Krystal>
References: <20110119182052.GB18970@Krystal>
	<20110119.134428.71569409.davem@davemloft.net>
	<20110119221538.GB23544@Krystal>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Wed, 19 Jan 2011 17:15:38 -0500

> * David Miller (davem@davemloft.net) wrote:
>> If plain "__long_aligned" works and, since you're tagging it to the structure
>> definition, it only specifies a minimum-alignment, then I'm fine with using
>> that to fix this.
> 
> I'd prefer to add the "packed" to ensure that gcc never decides for some odd
> reason to use an alignment larger than the one we specify in the linker script.

Agreed.
