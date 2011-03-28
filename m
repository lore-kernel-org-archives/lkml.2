Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab1C1Tae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 15:30:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33940 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab1C1Tad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 15:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=NZlgXX+0vvKqG/z7DAZCH1EVXJjzmCMqgcLoQ+Vn2vvFX+g5nYovTUD/xiNRH/wgoZ
         0M08Kw+sRCBU5PFY/N1sSxorn+5oQ9qCtmQlpBqRD57kOZBab+mImkaRXT+mAlKxnRRv
         wDfLw66y2m1yFHRQXo2vRQdaNqVI7L3XZEdTU=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: simon@mungewell.org
Subject: Re: 2.6.38 Regression: Nvidia GeForce8400 + i915 = Crash on Boot
Date: Mon, 28 Mar 2011 21:30:26 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <fe471c05897776b7c26b9fd2603e3b76.squirrel@host171.canaca.com>
In-Reply-To: <fe471c05897776b7c26b9fd2603e3b76.squirrel@host171.canaca.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103282130.27079.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=32072
for your bug report, please add your address to the CC list in there, thanks!

On czwartek, 24 marca 2011 o 16:20:19 simon@mungewell.org wrote:
> Quick summary is that I have a GeForce8400 installed in a Thinkcenter with
> on-board i915 graphics. 2.6.38 fails to boot, 2.6.37rcX is OK.
> 
> There appears to be some interaction between the nouveau and i915 drivers,
> disabling the i915 enables system to boot. I am unable to disable on board
> graphics in the BIOS (IBM special).
> 
> Full details/logs here:
> https://bugs.launchpad.net/ubuntu/+bug/741434
> 
> Let me know if there is any further testing I can do to help,
> Simon.
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
