Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab1DFVWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:22:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53921
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756858Ab1DFVWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:22:34 -0400
Date: Wed, 06 Apr 2011 14:21:57 -0700 (PDT)
Message-Id: <20110406.142157.68145422.davem@davemloft.net>
To: emunson@mgebm.net
Cc: dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, kaber@trash.net,
        zbr@ioremap.net, gregkh@suse.de, ksrinivasan@novell.com,
        netdev@vger.kernel.org
Subject: Re: 2.6.39-rc2 boot crash
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110406212041.GA2596@mgebm.net>
References: <20110406184753.GA7691@mgebm.net>
	<1302115953.8094.217.camel@nimitz>
	<20110406212041.GA2596@mgebm.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric B Munson <emunson@mgebm.net>
Date: Wed, 6 Apr 2011 17:20:41 -0400

> A bisect points at commit 04f482faf50535229a5a5c8d629cf963899f857c for the
> first bad one.  Unfortunately, I have not made netconsole work yet and the
> hang is happening mostly right when X starts so I can't even see the console.
> I will keep at the netconsole and see if I can get it functioning, also I will
> try to boot this kernel in a VM and see if that helps.

Patrick, please help Eric so we can fix this bug.

Thanks.
