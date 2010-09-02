Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab0IBIQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 04:16:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61098 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab0IBIQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 04:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=eDQdiNHpo5Mz/juJqmWGQHuQ4bHD8H0uVbCejfIT34LWaywe6du76jwUb+L9MfOs5d
         zCLMYXn8rXC36EnAXWHhneZeB/OSvNx5ESVmTlPImUUGGTYFr1sKz/hELsK7wlXF8fVW
         sJjOxScbgGeY3a6NAHBRqZv3Ap6q89OoOKb6k=
MIME-Version: 1.0
In-Reply-To: <1283414220.2059.1789.camel@laptop>
References: <4C7E2CA9.9060702@cn.fujitsu.com> <1283354736.2059.1206.camel@laptop>
 <4C7F39B3.4000901@cn.fujitsu.com> <1283414119.2059.1785.camel@laptop> <1283414220.2059.1789.camel@laptop>
From: "chxanders@gmail.com" <chxanders@gmail.com>
Date: Thu, 2 Sep 2010 15:16:09 +0700
Message-ID: <AANLkTinT3X+7hA9UvS8nKqpVzz1u1e-7UZNbfL_1UeX8@mail.gmail.com>
Subject: Re: [PATCH 1/3] lib: introduce some memory copy macros and functions
To: Peter Zijlstra <peterz@infradead.org>
Cc: miaox@cn.fujitsu.com, Ingo Molnar <mingo@redhat.com>,
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

On 2 September 2010 14:07, Chris Samuel <chris@csamuel.org> wrote:
> On 02/09/10 16:50, Miao Xie wrote:
>
>> I just change the "2.1" to "2" in your patch, because the
>> orignal code is LGPL v2.1, LGPL v2.1 permits us to apply
>> the terms of the ordinary GNU General Public License instead
>> of it.
> Ahhh excellent, I hadn't realised that was possible; well spotted!
Umm, isn't the only one that can do that the copyright holder?
Disclaimer: I am not a laywer
