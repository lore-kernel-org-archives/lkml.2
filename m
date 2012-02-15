Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab2BOUhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:37:05 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56681 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab2BOUhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:37:03 -0500
Message-ID: <4F3C1771.1050204@gmail.com>
Date: Wed, 15 Feb 2012 15:37:05 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: kill dead prev_priority stubs
References: <20120215192708.31690.2819.stgit@zurg>
In-Reply-To: <20120215192708.31690.2819.stgit@zurg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2/15/12 2:27 PM), Konstantin Khlebnikov wrote:
> This code was removed in v2.6.35-5854-g25edde0
> ("vmscan: kill prev_priority completely")
>
> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> ---
>   include/linux/memcontrol.h |   15 ---------------
>   1 files changed, 0 insertions(+), 15 deletions(-)

Oh, thank you.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



