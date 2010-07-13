Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab0GMIZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 04:25:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45300 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab0GMIZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 04:25:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C3C22DD.50807@s5r6.in-berlin.de>
Date: Tue, 13 Jul 2010 10:25:01 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH 08/36] drivers/ieee1394: Remove unnecessary casts of private_data
References: <cover.1278967120.git.joe@perches.com> <e7f254831d031e2d847f7fcf0ecdf992abfad40d.1278967120.git.joe@perches.com>
In-Reply-To: <e7f254831d031e2d847f7fcf0ecdf992abfad40d.1278967120.git.joe@perches.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/ieee1394/dv1394.c    |    4 ++--
>  drivers/ieee1394/raw1394.c   |    4 ++--
>  drivers/ieee1394/video1394.c |    6 +++---
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/ieee1394/dv1394.c b/drivers/ieee1394/dv1394.c
> index f8fcbd0..c5a031b 100644
> --- a/drivers/ieee1394/dv1394.c
> +++ b/drivers/ieee1394/dv1394.c
> @@ -172,7 +172,7 @@ static DEFINE_SPINLOCK(dv1394_cards_lock);
>  
>  static inline struct video_card* file_to_video_card(struct file *file)
>  {
> -	return (struct video_card*) file->private_data;
> +	return file->private_data;
[...]

Committed to linux1394-2.6.git.

drivers/ieee1394/ is both frozen and obsolete code that is scheduled for
removal.  But this change is obvious enough to be applied nevertheless
before that code finally goes away.
-- 
Stefan Richter
-=====-==-=- -=== -==-=
http://arcgraph.de/sr/
