Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab0EGIcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:32:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34719 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab0EGIcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:32:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bDnMOi4LMj1iuLoUCSjowqeJ6oVQSIPs0Cj8iML2TPYlk6EnCLTbJbbgRxQ+a8vsLF
         a/sTQDJnChbRjTWusLsKLyk51cKf3HCf/hH4+4fRNG1oGzvCXvC5uTI08h+yPYI6qg5l
         MQN8aBo4j8uNZxUXj+U4O1nA+tnzJg4/yuWjs=
Message-ID: <4BE3D03F.2010705@gmail.com>
Date: Fri, 07 May 2010 01:33:03 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Lex Hider <floss@lex.hider.name>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regression: monitor fails to sleep/suspend, forced to reboot
 to 	correct. 2.6.34-rc6
References: <AANLkTingM7EsCtbElXTNzzjZt4kG5acQtbt5mJEIVbrW@mail.gmail.com> <AANLkTiku49O-IKX0NwDtUoDEQyRT2VPcKiNVrSMbOR38@mail.gmail.com>
In-Reply-To: <AANLkTiku49O-IKX0NwDtUoDEQyRT2VPcKiNVrSMbOR38@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>      Can you do a bisect?
>      (2.6.32 - HEAD shouldn't
>      take too long).
>
>      Justin P. Mattock
>
>
> I'm still a git newbie. What specific command should I run and what
> output to post?
> You want me to do it against HEAD vs "latest known working version"?
>
> Thanks,
>
> Lex.
> --
sure.. it's easy(just requires patience).

do a:(in the source tree of kernel)
gist bisect start (enter)
git bisect bad (v2.6.*something, and/or enter for the current)
then
git bisect good v2.6.33
(git bisect will think)
then
make menuconfig
make (compile, reboot etc..)
if it's a good kernel then
(in source tree)
git bisect bad(if the problem is still there git bisect bad).
then
keep going until git gives it's idea of the problem
(then cry and complain to the authors that they fu*ked it up
just messn);

hope this help.

Justin P. Mattock
