Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934319Ab2FENva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:51:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48603 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934008Ab2FENv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:51:29 -0400
MIME-Version: 1.0
In-Reply-To: <1338904039.28282.180.camel@twins>
References: <1338520856-21020-1-git-send-email-zheng.z.yan@intel.com>
	<CABPqkBScjC5fJbTc1rYtbtRqOCyJ+7QUbdE32DgMcffBAGJNVw@mail.gmail.com>
	<CAAM7YAkYgUjwQptYvyeVawzcD5x4c-bTT_=+6AMyUb+-6HoMuQ@mail.gmail.com>
	<1338891271.28282.155.camel@twins>
	<CABPqkBSv8CbMzUiRsN2uOF1v6rFTpzhQqNbo7OKe-nzsus0GDg@mail.gmail.com>
	<1338892071.28282.157.camel@twins>
	<CABPqkBSqLpa4X-WbR0PkouYvhODT78r3pxWq70=PTj1j=a307Q@mail.gmail.com>
	<1338898024.28282.160.camel@twins>
	<1338899999.28282.164.camel@twins>
	<CABPqkBRCMAnPH3UW0=afMw4-YXgwQ5D-NLMEtnNWde_Tzh3aew@mail.gmail.com>
	<1338901490.28282.167.camel@twins>
	<CABPqkBRF_2LXE-54tLMBnQgLKbKyR9qo+4VohQiOchpqe1pgyw@mail.gmail.com>
	<1338903164.28282.177.camel@twins>
	<CABPqkBQ0OM__Ny9N9ZunKc2nCoqBH+cFY91CUH19xNUbM5NmGw@mail.gmail.com>
	<1338904039.28282.180.camel@twins>
Date: Tue, 5 Jun 2012 15:51:27 +0200
Message-ID: <CABPqkBSMi1ru3Grdh0kyBf6cqLk+=ugy66E0a6KFvFYzmjbgtQ@mail.gmail.com>
Subject: Re: [PATCH] perf: Fix intel shared extra msr allocation
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 3:47 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2012-06-05 at 15:38 +0200, Stephane Eranian wrote:
>
>> Will try it on my systems. Though it appears the patch has some
>> ^M all over.
>
> Yeah, stupid evolution can only do quoted-printable these days..
> progress they call this :/
>
> I can send you an awk script to unmangle it if you want.. but git can do
> it too somehow.

Will try with git, otherwise can do it manually, patch is small enough.
Thanks.
