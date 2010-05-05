Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab0EEUAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:00:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:24714 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab0EEUAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:00:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=js/BJ+XPu94UbfG+DER9re7z6CB/M4TlO4rj2jEL2uVD2WZ0On/tcLb2b822JWpey6
         LZxmWj2ArvdxGGBscbHaFwAAPTvg214OonIVcPfstqCuhbKTTojdipyHFCLIDvgRhlbn
         K4/DKGqozTPhHLlHUxSzdJKc74j1QEgzs8IMI=
From: Christian Lamparter <chunkeey@googlemail.com>
To: dhlii@dlasys.net
Subject: Re: 2.6.34-rc6 pci bridge problems
Date: Wed, 5 May 2010 21:59:55 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-rc6-uber-wl; KDE/4.4.3; x86_64; ; )
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <4BDC001F.9050202@dlasys.net> <201005021452.01101.chunkeey@googlemail.com> <4BE1BBD6.3030505@dlasys.net>
In-Reply-To: <4BE1BBD6.3030505@dlasys.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005052159.55871.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 May 2010 20:41:26 David H. Lynch Jr. wrote:
> When I build out of the wireless-testing git tree (puled today) 
> 2.6.34-rc6 using my current systems .config I get a very quick error
> on boot about PCI bridge windows.
> googling the error indicates this is a know 2.6.34 problem and that 
> there are fixes in other 2.6.34 trees.
> I have been unable to find the actual patches or I would just apply 
> them to wireless-testing.
so? If there is already a patch available, then the linux-pci people
have to know something about it. I'm sure they can help you out there.
Just describe your problem in detail (a extensive checklist is located in
your kernel's root directory "REPORTING-BUGS" file) as a reply to this mail.

I simply can't give you any support for problems I know nothing about.
So please, concentrate your questions around this particular device and
interaction with firmware and driver. But as I said in my previous mail,
you don't need a special kernel driver. *carlu* really is a userspace-only
application that can communicate with the device (through the use of
libusb) at the "lowest level". It may be even possible to port the code to
other platforms (FreeBSD & Mac OS X, Windows) with little effort.

Regards,
	Chr
