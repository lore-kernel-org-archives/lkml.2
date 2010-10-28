Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab0J1PtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:49:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:25815 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab0J1PtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:49:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,253,1286175600"; 
   d="scan'208";a="341661178"
Message-ID: <4CC99B73.6040201@linux.intel.com>
Date: Thu, 28 Oct 2010 08:49:07 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Ian Campbell <Ian.Campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com> <20101027104020.GA16954@a1.tnic> <4CC85839.4000507@goop.org> <4CC85EE6.7030608@linux.intel.com> <4CC861F9.8080200@goop.org> <20101027174417.GA19194@a1.tnic> <1288202321.10179.102.camel@localhost.localdomain> <1288257797.8361.1545.camel@zakaz.uk.xensource.com> <20101028112052.GA21757@a1.tnic>
In-Reply-To: <20101028112052.GA21757@a1.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2010 4:20 AM, Borislav Petkov wrote:
>
>> BTW, are there plans to unify 32 and 64 bit WRT the use of
>> swapper_pg_dir vs initial_page_table?
>
> To be honest, I thought about it but 64bit does the bootstrapping
> differently. I'll look into it one fine day when there's time. (like
> there ever is :))
>

The delta between the early 32- and 64-bit code is one of our big 
problems at the moment.

	-hpa
