Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab2JKXSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 19:18:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:39286 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758462Ab2JKXSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 19:18:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,573,1344236400"; 
   d="scan'208";a="204564167"
Message-ID: <507753AB.2050204@zytor.com>
Date: Fri, 12 Oct 2012 07:18:03 +0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] x86, mm: get early page table from BRK
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org> <1349757558-10856-4-git-send-email-yinghai@kernel.org> <20121009160133.GF7639@phenom.dumpdata.com> <CAE9FiQW8ubsQmtJk=bvZ5yGdBaBQSNWPpuACku+8sbb6_CG+rA@mail.gmail.com> <20121010141707.GH4005@phenom.dumpdata.com> <CAE9FiQVTUsYZiU0rAjE645Pez1X5eLwHMhOF0W_EuR62KYdtQQ@mail.gmail.com> <20121011144130.GB2408@localhost.localdomain> <CAE9FiQXWQCdawOw3QX6-c6ajQE73oZd0qrEnbisK0qOyQzUgSQ@mail.gmail.com>
In-Reply-To: <CAE9FiQXWQCdawOw3QX6-c6ajQE73oZd0qrEnbisK0qOyQzUgSQ@mail.gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 06:55 AM, Yinghai Lu wrote:
> On Thu, Oct 11, 2012 at 7:41 AM, Konrad Rzeszutek Wilk
> <konrad@kernel.org> wrote:
>> On Wed, Oct 10, 2012 at 08:49:05AM -0700, Yinghai Lu wrote:
>>>
>>> yes that is some extreme case:
>>> assume that 2M range is [2T-2M, 2T),
>>
>> What is T in here? Terabyte? Is the '[' vs ')' a significance in your
>> explanation? Should it be '[2T-2M, 2T]' ?
> 
> yes, T is terabyte
> 
> [2T-2M, 2T) is equal to [2T-2M, 2T-1]
> 
> ) mean the boundary is not included.
> 

Right... and just to defend Yinghai here, this is a standard
mathematical notation.

	-hpa


