Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0C1SDz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 14:03:55 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46167 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab0C1SDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 14:03:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=v+BXEStDGoaJ/WRnE7mDjz/A9BoXHjB8tKlMphQg63yLb0xAn16pzoaCvR1E/ObD9u
         hAkSkBLTdn7rNLbZUbIF+R9toiLViUUXSVX2t+NP/3jF9UeWGjtr515nACUtU4zv96yr
         C16QG3ruqzQyaoxGRNEgGkJlsVQNGSFj2+A2M=
Message-ID: <4BAF9A23.9080901@gmail.com>
Date: Sun, 28 Mar 2010 11:04:19 -0700
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-fbdev@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: adding some machines to efifb.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed in efifb.c that there is no
entry for MacbookPro2,2 and iMac9,1

I've spent the last few days looking into this, but
had no luck i.g. finding the physical address
of the framebuffer seems a bit tricky for my knowledge.

I do have these machines, if it's possible I'd like to
add these machines, but need info on what/where I might
find these addresses to add to efifb.c
(example)
} dmi_list[] = {
		[M_MB] = { "macbook", 0x80000000, 2048 * 4, 1280, 800 },

I've tried punching in random numbers, but came to the conclusion
that in order to run grub efi, and or elilo I would
have to change some things(partition).

Any info would be appreciated and/or I can supply
info to somebody etc...

Justin P. Mattock
