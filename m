Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab0CTTzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 15:55:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:19844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab0CTTzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 15:55:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=B2xc5JCroaY9sco0hP0gNg5NSewm/TmOrosjG7c9NaWIH6D4GV1cVxCiQ9liUkr9lI
         let5cHU9V7LcTG5i2Zs7sOvq598hrYx53cdAnaAOHeblhRRuAXqQi4qm/uZ2fOgEGQBq
         8tG4GEgHx8jPlIIlqXmRZLvLECg8Vz5dK3Mno=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.34-rc1: regression: ^Z no longer stops sound
Date: Sat, 20 Mar 2010 20:55:46 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33; KDE/4.3.4; i686; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>
References: <20100314075831.GA13457@elf.ucw.cz>
In-Reply-To: <20100314075831.GA13457@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003202055.46933.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 14 marca 2010 o 08:58:31 Pavel Machek wrote:
> Hi!
> 
> In 2.6.33, hitting ^Z stopped mpg123 in a way you'd expect (both on
> thinkpad and geode notebook).
> 
> On 2.6.34-rc1, hit ^Z and sound starts looping.
> 									Pavel
> 
I created a Bugzilla entry at  
https://bugzilla.kernel.org/show_bug.cgi?id=15590
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
