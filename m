Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936272Ab0CONlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:41:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab0CONls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:41:48 -0400
Message-ID: <4B9E38EA.6040205@redhat.com>
Date: Mon, 15 Mar 2010 09:40:58 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: remove return value of putback_lru_pages
References: <1268658994.1889.8.camel@barrios-desktop>
In-Reply-To: <1268658994.1889.8.camel@barrios-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 09:16 AM, Minchan Kim wrote:
>
> Now putback_lru_page never can fail.
> So it doesn't matter count of "the number of pages put back".
>
> In addition, users of this functions don't use return value.
>
> Let's remove unnecessary code.
>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>

Reviewed-by: Rik van Riel <riel@redhat.com>
