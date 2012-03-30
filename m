Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965913Ab2C3Vvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:51:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46049 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965755Ab2C3VTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:19:51 -0400
Message-ID: <4F762360.1090203@fb.com>
Date: Fri, 30 Mar 2012 14:19:28 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: revert comment for atomic64_add_unless().
References: <4F761E1C.80808.com> <201203302104.q2UL4sGo006256@farm-0012.internal.tilera.com>
In-Reply-To: <201203302104.q2UL4sGo006256@farm-0012.internal.tilera.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-03-30_06:2012-03-30,2012-03-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/12 11:10 AM, Chris Metcalf wrote:
> --- a/arch/tile/include/asm/atomic_32.h
> +++ b/arch/tile/include/asm/atomic_32.h
> @@ -199,7 +199,7 @@ static inline u64 atomic64_add_return(u64 i, atomic64_t *v)
>    * @u: ...unless v is equal to u.
>    *
>    * Atomically adds @a to @v, so long as @v was not already @u.
> - * Returns the old value of @v.
> + * Returns non-zero if @v was not @u, and zero otherwise.
>    */
>   static inline u64 atomic64_add_unless(atomic64_t *v, u64 a, u64 u)
>   {

Acked-by: Arun Sharma <asharma@fb.com>
