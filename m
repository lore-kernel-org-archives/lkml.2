Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab1CUURk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 16:17:40 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:44108 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754484Ab1CUURf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 16:17:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=DEH/M8AiRrKGte/4CsA22+V+WKLGLWknLMmnR8z4ERZnpl0dK9KGDvuulVLBwflApM2ZKObSMKrqgmGX+By43B9P5hTv/QJMUN3Xp2UnahvC5I3WITNPYdWblknOtK6x;
Date: Mon, 21 Mar 2011 13:17:32 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Alan Ott <alan@signal11.us>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Jiri Kosina <jkosina@suse.cz>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefani Seibold <stefani@seibold.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v5 0/2] Documentation and Sample for hidraw
Message-Id: <20110321131732.8e8906a8.rdunlap@xenotime.net>
In-Reply-To: <1300580985-10726-1-git-send-email-alan@signal11.us>
References: <1297829209-10511-1-git-send-email-alan@signal11.us>
	<1300580985-10726-1-git-send-email-alan@signal11.us>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Mar 2011 20:29:43 -0400 Alan Ott wrote:

> Sorry I've been slack in getting v5 of this patch out. Because
> it's been so long, I'll recap what happened last time:
> 
>  * Jon Corbet suggested that the example programs be moved into samples/ .
>  * Randy Dunlap indicated his acked-by when this was done.
> 
> These patches add hidraw.txt to a new Documentation/hid/ directory.
> 
> It creates an example program which is now in samples/ with a Kconfig item.
> 
> The existing hiddev.txt has been moved from Documentation/usb/ to
> Documentation/hid/

Jiri,

I suppose that you will merge these patches?
or did you want me to do it?


> This is based on .38+
> 
> Alan Ott (2):
>   HID: Documentation for hidraw
>   HID: Move hiddev.txt to the new Documentation/HID directory
> 
>  Documentation/{usb => hid}/hiddev.txt |    0
>  Documentation/hid/hidraw.txt          |  119 +++++++++++++++++++++++
>  samples/Kconfig                       |    6 +
>  samples/Makefile                      |    2 +-
>  samples/hidraw/Makefile               |    8 ++
>  samples/hidraw/hid-example.c          |  167 +++++++++++++++++++++++++++++++++
>  6 files changed, 301 insertions(+), 1 deletions(-)
>  rename Documentation/{usb => hid}/hiddev.txt (100%)
>  create mode 100644 Documentation/hid/hidraw.txt
>  create mode 100644 samples/hidraw/Makefile
>  create mode 100644 samples/hidraw/hid-example.c
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
