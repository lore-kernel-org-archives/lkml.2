Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1EXRJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:09:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54480 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab1EXRJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:09:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WAFFRBubTaLwaN+CJF+SPf653Zh15rvsXUpr81jNbnaO1mOtvyv/iEOotYlu3QLXID
         FrWS1PLUfyyBmyS+v0tPEt3XsRyegO5n8Nh8wGkw9GA1ScHV/Tq08ghD1wezRPZvDy0C
         MJ9dtxmLM9XslY8IjhMty0Cpe+Hkm1f8AgcHI=
Message-ID: <4DDBE4D5.9010000@gmail.com>
Date: Tue, 24 May 2011 19:03:17 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stevie Trujillo <stevie.trujillo@gmail.com>
CC: linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
        kmpark@infradead.org
Subject: Re: ramoops: is using platform_drivers correct?
References: <201105231527.53805.stevie.trujillo@gmail.com>
In-Reply-To: <201105231527.53805.stevie.trujillo@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/05/2011 15:27, Stevie Trujillo ha scritto:
> Hello,
>
> ramoops (drivers/char/ramoops.c) is for "all" computers right? When I try to

Yes, or at least was my intention. It's true that this drivers is useful 
when you use an NVRAM, this is typical for the embedded world where the 
platform driver approach is more diffused. Sure at this point the module 
parameters are not useful. In addition the platform data struct doesn't 
define a way to select if to dump only oops. At the end I think a patch 
it's needed here. I have to look at the code to see if it's possible to 
use the platform data OR module parameters. I'll submit a patch.

Marco
