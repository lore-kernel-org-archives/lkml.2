Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab0FVVQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 17:16:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40056
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755611Ab0FVVQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 17:16:10 -0400
Date: Tue, 22 Jun 2010 14:16:22 -0700 (PDT)
Message-Id: <20100622.141622.15223630.davem@davemloft.net>
To: vst@vlnb.net
Cc: sparclinux@vger.kernel.org, simone.ricci@gmail.com,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Nick.Couchman@seakr.com, mmarek@suse.cz, linux-kbuild@vger.kernel.org
Subject: Re: Error "Unknown relocation: 36" on module load on Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C210A07.80906@vlnb.net>
References: <4C192085.2090404@vlnb.net>
	<20100616.133540.189696272.davem@davemloft.net>
	<4C210A07.80906@vlnb.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladislav Bolkhovitin <vst@vlnb.net>
Date: Tue, 22 Jun 2010 23:07:51 +0400

> But we surprised that such platform specific compiler flags have to be
> manually maintained by out of the kernel tree modules developers.

You don't, Kbuild should do it transprently for you.

It's possible you're simply not using kbuild correctly
for external module builds, or something in your Makefile
is overriding the arch specific CFLAGS.
