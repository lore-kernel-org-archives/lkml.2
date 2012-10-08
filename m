Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab2JHGgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:36:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56531 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab2JHGgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:36:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQV_xVsHN_+6ui_Vgnn6tk8UBOEKL+0XnoEN9VLw3gcOXA@mail.gmail.com>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
	<1348991844-12285-5-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com>
	<CAE9FiQUMMRPb2u13R2b7hHSOTgb4jKcnbAace7T22_GCm=-HxQ@mail.gmail.com>
	<20121004164551.GA2244@phenom.dumpdata.com>
	<CAE9FiQWjXhat85JpXhCLApGe62mdCwb2HKhWGLjQdj2ed=6buA@mail.gmail.com>
	<CAE9FiQVnTqWx808F_CWaiGXT12Y4rfKPOERtSgGb=2t_4T44+A@mail.gmail.com>
	<506E029E.3000102@zytor.com>
	<CAE9FiQWPNmsw9OMrdP7Q0JnjGv66PBkAcJQhizUm0Kji-yvw8g@mail.gmail.com>
	<506E059B.40808@zytor.com>
	<CAE9FiQW2-mZHbBeUZcLY-nyb41TDvr7uonnfdAeAML5rc_ZhfA@mail.gmail.com>
	<alpine.DEB.2.02.1210051205390.29232@kaball.uk.xensource.com>
	<CAE9FiQV_xVsHN_+6ui_Vgnn6tk8UBOEKL+0XnoEN9VLw3gcOXA@mail.gmail.com>
Date: Sun, 7 Oct 2012 23:36:09 -0700
X-Google-Sender-Auth: yiV7jg1otj363AAd7IaFckNoYls
Message-ID: <CAE9FiQXaDWEQETbqCVXzswJGCM8np=k=rwZSMKS5NEWBAMb5zw@mail.gmail.com>
Subject: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 5, 2012 at 7:58 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Oct 5, 2012 at 4:27 AM, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
>> On Fri, 5 Oct 2012, Yinghai Lu wrote:
>>> On Thu, Oct 4, 2012 at 2:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> >
>>> > See my other post.  This is bringing up the Kernel Summit algorithm again.
>>> >
>>>
>>> sure. please check if you are ok with attached one on top of x86/mm2

I updated my for-x86-mm branch, It should be ok now with xen.

Can you please check it ?

	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-mm

in addition patches in tip x86/mm2, there are 5 new patches added.

688d437: x86, mm: Use big page for small memory range
41e562f: x86, mm: only keep initial mapping for ram
24ac352: x86, mm: Remove early_memremap workaround for page table accessing
d9dd599: x86, mm: Don't clear page table if next range is ram
080acbe: x86, mm: get early page table from BRK

Thanks

Yinghai
