Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab0LHUDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:03:12 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:55866 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118Ab0LHUDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:03:10 -0500
Message-ID: <4CFFE46C.60401@euromail.se>
Date: Wed, 08 Dec 2010 21:02:52 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
CC: Chase Douglas <chase.douglas@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Add an envelope tool type
References: <1291721340-22652-1-git-send-email-rydberg@euromail.se> <4CFFC3C2.1080905@canonical.com> <4CFFCD10.5030202@euromail.se> <4CFFD0BF.2020601@canonical.com> <4CFFD3FE.1090103@euromail.se> <4CFFD801.8060704@canonical.com> <4CFFDB35.2020506@euromail.se> <AANLkTi=iw+7CDhbO4N9rMVSwS0t93BaaBVgoAwz-GeHo@mail.gmail.com>
In-Reply-To: <AANLkTi=iw+7CDhbO4N9rMVSwS0t93BaaBVgoAwz-GeHo@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PQQE3-0000ZL-5C.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PQQE3-0000ZL-5C b42dcce3f602924246e129e23c5a5931
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 08:51 PM, Mohamed Ikbel Boulabiar wrote:

> I have seen this touchless touchpad hardware (huh?)
> it detects finger/hand and it's better explained by a video:
> http://www.youtube.com/watch?v=6SjMdtdhXlA
> 
> How it fit in the convex notion?


This is precisely what the patch for ABS_MT_DISTANCE is for. Perhaps you meant
to comment on that email. This one is about support for hardware without
individual finger detection capabilities.

Henrik
