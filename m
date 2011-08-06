Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab1HFPSt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 11:18:49 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33997 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752192Ab1HFPSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 11:18:46 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX197f7wOQ2p7nyb9qbVHBcMNPW831DFkG7OG8Zby/w
	7LvW0nPC17oD5U
Message-ID: <4E3D5B52.5030907@gmx.de>
Date: Sat, 06 Aug 2011 15:18:42 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: Wang Shaoyan <stufever@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        lethal@linux-sh.org, Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: Re: [PATCH] viafb: fix pointer type missmatch
References: <1312637180-6107-1-git-send-email-wangshaoyan.pt@taobao.com>	<4E3D5154.2040808@gmx.de> <CANxBZFpxO40BE6iTGw3ad9+685_sAZettg+H6VQfB-X7cFbvhw@mail.gmail.com>
In-Reply-To: <CANxBZFpxO40BE6iTGw3ad9+685_sAZettg+H6VQfB-X7cFbvhw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

okay, it was not obvious that "stufever@gmail.com" is the same person as "Wang 
Shaoyan". Now that I know it it's okay. Maybe you want to adjust your config 
(maybe user.name in git) to give others a hint that they are the same.
I will apply your patch to my tree when linux-next is reopened for new material 
(when -rc1 is released).


Thanks,

Florian Tobias Schandinat

On 08/06/2011 03:03 PM, Wang Shaoyan wrote:
> hi, the gmail is just to send patch, I have to use it, because my work
> mail server will append some spam information. So my signed-off-by is
> right author, that's why I add an obvious "From:". Sorry to trobule
> you.
>
>> But as I assume you, who sent this email, are not the original author,
>> please resent it with your Signed-off-by added. (as keeping track who
>> received the patch from whom is one reasons for having those)
>
>

