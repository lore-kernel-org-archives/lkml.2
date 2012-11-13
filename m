Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab2KMIan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:30:43 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:56398 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2KMIaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:30:13 -0500
Message-ID: <50A20512.10805@suse.cz>
Date: Tue, 13 Nov 2012 09:30:10 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Sound+USB: deadlock problem
References: <50A20429.3020109@suse.cz> <s5ha9ulx5xe.wl%tiwai@suse.de>
In-Reply-To: <s5ha9ulx5xe.wl%tiwai@suse.de>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 09:28 AM, Takashi Iwai wrote:
> At Tue, 13 Nov 2012 09:26:17 +0100,
> Jiri Slaby wrote:
>>
>> Hello,
>>
>> I've just plugged+unplugged+plugged my USB audio card and the audio
>> subsystem got stuck:
> 
> Which kernel?  If it's older than 3.7-rc5, could you try 3.7-rc5?

Oh, forgot to mention:
3.7.0-rc5-next-20121112_64+

thanks,
-- 
js
suse labs
