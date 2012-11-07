Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2KGOQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:16:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab2KGOQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:16:43 -0500
Message-ID: <509A6DDA.9090109@redhat.com>
Date: Wed, 07 Nov 2012 09:19:06 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: Re: [RFC 3/3] man-pages: Add man page for vmpressure_fd(2)
References: <20121107105348.GA25549@lizard> <20121107110152.GC30462@lizard>
In-Reply-To: <20121107110152.GC30462@lizard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 06:01 AM, Anton Vorontsov wrote:

>     Configuration
>         vmpressure_fd(2) accepts vmpressure_config structure to configure
>         the notifications:
>
>         struct vmpressure_config {
>              __u32 size;
>              __u32 threshold;
>         };
>
>         size is a part of ABI  versioning  and  must  be  initialized  to
>         sizeof(struct vmpressure_config).

If you want to use a versioned ABI, why not pass in an
actual version number?
