Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1ICDvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 23:51:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54831 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab1ICDvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 23:51:03 -0400
Date: Sat, 3 Sep 2011 11:50:37 +0800
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: "Palash Bandyopadhyay" <Palash.Bandyopadhyay@conexant.com>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Mauro Carvalho Chehab" <mchehab@redhat.com>,
        "Ruslan Pisarev" <ruslan@rpisarev.org.ua>,
        "Ilia Mirkin" <imirkin@alum.mit.edu>, "Joe Perches" <joe@perches.com>,
        "Hans Verkuil" <hverkuil@xs4all.nl>,
        "Youquan Song" <youquan.song@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH v4 00/19] Staging: cx25821: Fix style issues
Message-ID: <20110903115037.184dd503@inspire>
In-Reply-To: <34B38BE41EDBA046A4AFBB591FA311320502550FA8@NBMBX01.bbnet.ad>
References: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
	<34B38BE41EDBA046A4AFBB591FA311320502550FA8@NBMBX01.bbnet.ad>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Sep 2011 09:05:41 -0700
"Palash Bandyopadhyay" <Palash.Bandyopadhyay@conexant.com> wrote:

> Thanks a lot Leonid. Changes look good to me.
My pleasure. Thank you for the review.

> 
> Regards,
> Palash
> 
> -----Original Message-----
> From: Leonid V. Fedorenchik [mailto:leonidsbox@gmail.com] 
> Sent: Thursday, September 01, 2011 8:55 PM
> To: Greg Kroah-Hartman
> Cc: Mauro Carvalho Chehab; Ruslan Pisarev; Ilia Mirkin; Joe Perches; Palash Bandyopadhyay; Hans Verkuil; Arnd Bergmann; Youquan Song; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; Leonid V. Fedorenchik
> Subject: [PATCH v4 00/19] Staging: cx25821: Fix style issues
> 
> This patch series fixes some style issues in drivers/staging/cx25821
> 
> I split my previous patches per logical change and combined them into
> one patch series.
> 
> Changes in v4 based on reviews of v3.
> 
> Leonid V. Fedorenchik (19):
>   Staging: cx25821: Get rid of typedef in cx25821.h
>   Staging: cx25821: Rename member name in struct cx25821_dev
>   Staging: cx25821: Delete file cx25821-gpio.h
>   Staging: cx25821: Move EXPORT_SYMBOL() to the right place
>   Staging: cx25821: Use DEFINE_PCI_DEVICE_TABLE for cx25821_pci_tbl
>   Staging: cx25821: Fix wrong statement indent in cx25821-cards.c
>   Staging: cx25821: Fix wrong statement indent in cx25821-core.c
>   Staging: cx25821: Fix wrong statement indent in cx25821-i2c.c
>   Staging: cx25821: Fix too long lines in cx25821-audio.h
>   Staging: cx25821: Fix obscure line endings in cx25821-audio-upstream.c
>   Staging: cx25821: Fix long lines in cx25821-audio-upstream.c
>   Staging: cx25821: Fix long lines in cx25821-audio-upstream.h
>   Staging: cx25821: Replace :? by if-else in cx25821-video-upstream-ch2.c
>   Staging: cx25821: Fix labels' placement in cx25821-video-upstream-ch2.c
>   Staging: cx25821: Fix wrong line endings in cx25821-video-upstream-ch2.c
>   Staging: cx25821: Fix long lines in cx25821-video-upstream-ch2.c
>   Staging: cx25821: Fix long lines in cx25821-video-upstream-ch2.h
>   Staging: cx25821: Fix long lines in cx25821-video-upstream.c
>   Staging: cx25821: Fix long lines in cx25821-video-upstream.h
> 
>  drivers/staging/cx25821/cx25821-audio-upstream.c   |   41 +-
>  drivers/staging/cx25821/cx25821-audio-upstream.h   |    9 +-
>  drivers/staging/cx25821/cx25821-audio.h            |    6 +-
>  drivers/staging/cx25821/cx25821-cards.c            |   26 +-
>  drivers/staging/cx25821/cx25821-core.c             |  503 ++++++++++----------
>  drivers/staging/cx25821/cx25821-gpio.c             |    1 +
>  drivers/staging/cx25821/cx25821-gpio.h             |    2 -
>  drivers/staging/cx25821/cx25821-i2c.c              |   30 +-
>  .../staging/cx25821/cx25821-video-upstream-ch2.c   |   79 ++--
>  .../staging/cx25821/cx25821-video-upstream-ch2.h   |   83 +++-
>  drivers/staging/cx25821/cx25821-video-upstream.c   |   16 +-
>  drivers/staging/cx25821/cx25821-video-upstream.h   |   78 +++-
>  drivers/staging/cx25821/cx25821.h                  |   10 +-
>  13 files changed, 465 insertions(+), 419 deletions(-)
>  delete mode 100644 drivers/staging/cx25821/cx25821-gpio.h
> 
> Conexant E-mail Firewall (Conexant.Com) made the following annotations
> ---------------------------------------------------------------------
> ********************** Legal Disclaimer **************************** 
> 
> "This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 
> 
> ********************************************************************** 
> 
> ---------------------------------------------------------------------
> 

Leonid V. Fedorenchik
