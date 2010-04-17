Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab0DQPVU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 11:21:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45561 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab0DQPVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 11:21:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=S5leJ9E4UvWY+Iz9hFjIc+RK4r5Y9RiYxZYuEkazOZWQoPk0MMyNxQn40n8WKVp5fG
         zmFMqX96bJp391qK/5vlHN0zCZQlTgFeUulX2wadjx48LVy8XpSjTBNgeipe/bxjZn8r
         49De9fSc2S4w4zxCEp5LaxWoL9M1ZkO/dFA7Q=
Message-ID: <4BC9D1E9.1090705@roadrunner.com>
Date: Sat, 17 Apr 2010 11:21:13 -0400
From: Frank Griffin <ftg@roadrunner.com>
Reply-To: ftg@roadrunner.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20090903 SeaMonkey/1.1.18
MIME-Version: 1.0
To: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
CC: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: [REGRESSION bisected] Sound goes too fast due to commit 7b3a177b0
References: <4BC4E812.6050602@tremplin-utc.net>	<s5h633u5zx1.wl%tiwai@suse.de>	<4BC5A566.8060106@tremplin-utc.net> <s5hy6gqvx9n.wl%tiwai@suse.de> <4BC782E5.7070900@tremplin-utc.net>
In-Reply-To: <4BC782E5.7070900@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Éric Piel wrote:
> In the case of Frank, this looks more like a regression, or at least a
> bug to solve, because this happens with the default options. However,
> this report should be taken with care, because this happens on a
> 2.6.33.2 kernel made by Mandriva, containing many alsa patches of
> 2.6.34. Frank, how possible would it be to test a 2.6.34-rc4 kernel from
> Linus?
>
>   

Done.  2.6.34-rc4 compiled with standard configuration and without 
"options snd-hda-intel position_fix=1" in modprobe.conf works perfectly: 
normal sound and normal playback speed.
