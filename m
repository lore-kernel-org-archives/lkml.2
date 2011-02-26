Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab1BZAyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 19:54:50 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:54674 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932105Ab1BZAyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 19:54:49 -0500
Subject: Re: [PATCH 06/21]drivers:media:cx23418.h remove one to many l's in
 the word.
From: Andy Walls <awalls@md.metrocast.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, mchehab@infradead.org, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1298614277-3649-1-git-send-email-justinmattock@gmail.com>
References: <1298614277-3649-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 19:51:18 -0500
Message-ID: <1298681478.2709.24.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-02-25_08:2011-02-25,2011-02-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1102250167
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 22:11 -0800, Justin P. Mattock wrote:
> The patch below removes an extra "l" in the word.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/media/video/cx18/cx23418.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/cx18/cx23418.h b/drivers/media/video/cx18/cx23418.h
> index 7e40035..935f557 100644
> --- a/drivers/media/video/cx18/cx23418.h
> +++ b/drivers/media/video/cx18/cx23418.h
> @@ -477,7 +477,7 @@
>  /* The are no buffers ready. Try again soon! */
>  #define CXERR_NODATA_AGAIN      0x00001E
>  
> -/* The stream is stopping. Function not alllowed now! */
> +/* The stream is stopping. Function not allowed now! */

If the spelling mistake is worthy of a fix, why isn't the egregious
grammar mistake also worth fixing?

Also, those aren't the only spelling and grammar mistakes in comments in
that file.

-Andy

>  #define CXERR_STOPPING_STATUS   0x00001F
>  
>  /* Trying to access hardware when the power is turned OFF */


