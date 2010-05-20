Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab0ETFs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 01:48:27 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44100 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab0ETFs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 01:48:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xZOGnrj/5SoY+o5otC3LGOzQDLaQQpl4JxT4brxuVO5pRYKyaTN4DKhx8nlksNv75/
         6hVicdWZefOc/DldXLR/LMWhWobkkcjk2fE506FKfHjn0nmTPbOKNJAgtiv28CmH04e8
         LyOiO/TwzUSq2JaqenQUEHzS+LZ9J0bapyH7E=
Message-ID: <4BF4CD22.4080509@gmail.com>
Date: Thu, 20 May 2010 13:48:18 +0800
From: Ang Way Chuang <wcang79@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 2.6.35] V4L/DVB updates
References: <20100519191837.6a01c559@pedra>
In-Reply-To: <20100519191837.6a01c559@pedra>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro/Linux DVB developers,

    Can someone please review the following patch asap?
https://patchwork.kernel.org/patch/97358/

    I may not have access to the testbed for long because I'm leaving my university soon. I had been using the fix introduced through this patch on my testbed since 2.6.32 and had not experienced any issue of dropped packets yet. If there is any problem with this patch, I can follow up while I'm still here. I would like take this opportunity to express my gratitude towards Linux DVB developers. Without you guys, I won't have any platform for my research. Thanks a lot.


Regards,
Ang Way Chuang
