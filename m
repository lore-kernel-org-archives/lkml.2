Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302Ab0HKCda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 22:33:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39180 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757928Ab0HKCd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 22:33:29 -0400
MIME-Version: 1.0
In-Reply-To: <1117369508.20100811005719@eikelenboom.it>
References: <61936849.20100811001257@eikelenboom.it>
	<AANLkTinVNms-vdfG-VZzkOadogaCRV+HyDAY5yhYOJSK@mail.gmail.com>
	<1117369508.20100811005719@eikelenboom.it>
Date: Tue, 10 Aug 2010 22:33:28 -0400
Message-ID: <AANLkTikPffMQLXcPF4-xPeZfkaAtnu7xEP0TMzYVrkgE@mail.gmail.com>
Subject: Re: [2.6.35] usb 2.0 em28xx kernel panic general protection fault: 
	0000 [#1] SMP RIP: 0010:[<ffffffffa004fbc5>] [<ffffffffa004fbc5>] 
	em28xx_isoc_copy_vbi+0x62e/0x812 [em28xx]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: mchehab@infradead.org, mrechberger@gmail.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 6:57 PM, Sander Eikelenboom
<linux@eikelenboom.it> wrote:
> Hello Devin,
>
> It's a k-world, which used to work fine (altough with another program, but I can't use that since it seems at least 2 other bugs prevent me from using my VM's :-)
> It's this model  http://global.kworld-global.com/main/prod_in.aspx?mnuid=1248&modid=6&pcid=47&ifid=17&prodid=104
>
> Tried to grab with ffmpeg.

Is it reproducible?  Or did it just happen once?  If you have a
sequence to reproduce, can you provide the command line you used, etc?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
