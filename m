Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab2JKWzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 18:55:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56559 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065Ab2JKWzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 18:55:40 -0400
MIME-Version: 1.0
In-Reply-To: <20121011144130.GB2408@localhost.localdomain>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
	<1349757558-10856-4-git-send-email-yinghai@kernel.org>
	<20121009160133.GF7639@phenom.dumpdata.com>
	<CAE9FiQW8ubsQmtJk=bvZ5yGdBaBQSNWPpuACku+8sbb6_CG+rA@mail.gmail.com>
	<20121010141707.GH4005@phenom.dumpdata.com>
	<CAE9FiQVTUsYZiU0rAjE645Pez1X5eLwHMhOF0W_EuR62KYdtQQ@mail.gmail.com>
	<20121011144130.GB2408@localhost.localdomain>
Date: Thu, 11 Oct 2012 15:55:39 -0700
X-Google-Sender-Auth: PwcUNJAwgp5L9AIatlwFVuyM8jI
Message-ID: <CAE9FiQXWQCdawOw3QX6-c6ajQE73oZd0qrEnbisK0qOyQzUgSQ@mail.gmail.com>
Subject: Re: [PATCH 03/10] x86, mm: get early page table from BRK
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 7:41 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
> On Wed, Oct 10, 2012 at 08:49:05AM -0700, Yinghai Lu wrote:
>>
>> yes that is some extreme case:
>> assume that 2M range is [2T-2M, 2T),
>
> What is T in here? Terabyte? Is the '[' vs ')' a significance in your
> explanation? Should it be '[2T-2M, 2T]' ?

yes, T is terabyte

[2T-2M, 2T) is equal to [2T-2M, 2T-1]

) mean the boundary is not included.
