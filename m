Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab0IBIgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 04:36:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50308 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab0IBIgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 04:36:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=VfbzM3JEovA0Fhg/0N5KL8TQ3zzGDftNF5EQGEivnWEcz8DjYW490UOd+JDg/5FcNH
         2NmGZcV/Rrf6fzemcFP1qmRinoEeBAHQQNW0tShDjyN6Kpv/b7dJ2Llpa8v6mx0dMGAk
         2e7A8NvMkE2FJbSX6X4pVPvEeIwBLGWVSg+LU=
MIME-Version: 1.0
In-Reply-To: <4C7F5F38.3050104@csamuel.org>
References: <4C7E2CA9.9060702@cn.fujitsu.com> <1283354736.2059.1206.camel@laptop>
 <4C7F39B3.4000901@cn.fujitsu.com> <1283414119.2059.1785.camel@laptop>
 <1283414220.2059.1789.camel@laptop> <AANLkTinT3X+7hA9UvS8nKqpVzz1u1e-7UZNbfL_1UeX8@mail.gmail.com>
 <4C7F5F38.3050104@csamuel.org>
From: "chxanders@gmail.com" <chxanders@gmail.com>
Date: Thu, 2 Sep 2010 15:35:53 +0700
Message-ID: <AANLkTi=8V+3HS-+o=FUbM20ZXZ6mDXb67dOgJiwiJb6y@mail.gmail.com>
Subject: Re: [PATCH 1/3] lib: introduce some memory copy macros and functions
To: Chris Samuel <chris@csamuel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, miaox@cn.fujitsu.com,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 September 2010 15:24, Chris Samuel <chris@csamuel.org> wrote:
> On 02/09/10 18:16, chxanders@gmail.com wrote:
>
>> Umm, isn't the only one that can do that the copyright holder?
>
> The copyright holder can use whatever license they wish; the LGPL
> tells the licensee what rights *they* have, which includes distributing
> the software under the (more strict) GPLv2.
>
Wow, there is even a FAQ.
http://www.gnu.org/licenses/gpl-faq.html#compat-matrix-footnote-7
in the matrix notes 1 and 7 apply, which means that anyone, not just
the license holder may change to GPL v2 from LGPV 2.1

Cheers

Chris
