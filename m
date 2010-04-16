Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab0DPKk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 06:40:56 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:59121 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754Ab0DPKky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 06:40:54 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Apr 2010 06:40:54 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=lLIWfkWiNb4ponijO9Ue58lYvQ32KQYvnvjvyxdbwI+69a3M2A6XcE1lKRBUzrvIAP
         2gdlCHDlHWbeXTnrX/z1+8b9mRP7Ah9Kf0dH91W01asx8DjrhsVlVmLYqTjnALDHGXuY
         kmTu04ixa31dlTaFJwV9ccygvgWsLi6Fw+qGg=
Message-ID: <4BC83D06.2050909@roadrunner.com>
Date: Fri, 16 Apr 2010 06:33:42 -0400
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
I'll try to do this over the weekend...
