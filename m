Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab1EYM2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:28:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757616Ab1EYM2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:28:02 -0400
Message-ID: <4DDCF5B2.3060209@redhat.com>
Date: Wed, 25 May 2011 08:27:30 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 2/3] swap-token: makes global variables to function local
References: <4DD480DD.2040307@jp.fujitsu.com>	<4DD481A7.3050108@jp.fujitsu.com> <20110520123004.e81c932e.akpm@linux-foundation.org> <4DDB1388.2080102@jp.fujitsu.com> <4DDC73B7.1050409@jp.fujitsu.com>
In-Reply-To: <4DDC73B7.1050409@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2011 11:12 PM, KOSAKI Motohiro wrote:
> global_faults and last_aging are only used in grab_swap_token().
> Then, they can be moved into grab_swap_token().
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
