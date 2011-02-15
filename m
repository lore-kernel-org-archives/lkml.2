Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1BOMsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 07:48:55 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:60210 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab1BOMsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 07:48:54 -0500
Date: Tue, 15 Feb 2011 09:48:43 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the bluetooth tree
Message-ID: <20110215124843.GH2597@joana>
References: <20110215131615.39f30d8a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215131615.39f30d8a.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

* Stephen Rothwell <sfr@canb.auug.org.au> [2011-02-15 13:16:15 +1100]:

> Hi Gustavo,
> 
> After merging the bluetooth tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "l2cap_load" [net/bluetooth/cmtp/cmtp.ko] undefined!
> 
> Caused by commit de5b38d18ca4f3f8b8e297211c3226c2a63226fe ("Bluetooth:
> remove l2cap_load() hack").

I fixed it. Thanks for finding this, CMTP was disabled by some reason in my
kernel. 

-- 
Gustavo F. Padovan
http://profusion.mobi
