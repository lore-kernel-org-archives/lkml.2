Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab0KXIMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:12:20 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61236 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab0KXIMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:12:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xfGYdLB2s6lbllSsYpO3WL/++ueTVh6DoSC9bJ7hXDYalU0e10fPy7jE0ISY8tIFS3
         DyASgYa5JAZ6myGdZ1SFyZo4KyQzD5Kis8BEA4hAzo2xdIec2GwjDKe5El1ny80vOnxs
         wFQz2xXJhdXYeg+Y+A21p5bcH6ORY3o5jOCns=
MIME-Version: 1.0
In-Reply-To: <20101123084309.GA17754@intel.com>
References: <20101123084309.GA17754@intel.com>
Date: Wed, 24 Nov 2010 17:12:17 +0900
X-Google-Sender-Auth: w0O1qj3ygBsw80KAc5sBaLVKeAY
Message-ID: <AANLkTinvfjAZOyuiM2T8Vtj-vxS59P1HNzjKAjPiOzb_@mail.gmail.com>
Subject: Re: [PATCH v1 0/4]mmc: enable eMMC4.41 new feature background
 operations and HPI
From: Kyungmin Park <kmpark@infradead.org>
To: Chuanxiao Dong <chuanxiao.dong@intel.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, arjan@linux.intel.com, hang.yuan@intel.com,
        =?UTF-8?B?7KCV7J6s7ZuI?= <jh80.chung@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Basic question. Do you have any performance gain or improvement?
In my test environment. no performance gain. Yes I know it's not for
performance improvement.

How to measure or check it has some improvement?
Any ideas?

Thank you,
Kyungmin Park

On Tue, Nov 23, 2010 at 5:43 PM, Chuanxiao Dong
<chuanxiao.dong@intel.com> wrote:
> Hi,
>        These patches were enabled eMMC4.41 standard new feature: background
>        operations and HPI.
>
>        Since these two features are opertional, driver only enable for those
>        eMMC card which supports them.
>
>        HPI can interrupt both background operations and low priority foreground
>        operations. In these patches, only implemented using HPI to interrupt
>        background operations.
>
>        patch1: enable background operations feature for supported eMMC card.
>        patch2: let eMMC card do background operations when user reqeust queue
>        is idle. In this patch, also considered when driver added runtime power
>        management.
>        patch3: enable HPI feature for supported eMMC card.
>        patch4: use HPI to interrupt background operations if there is user
>        request(foreground operations).
>
> Thanks
> Chuanxiao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
