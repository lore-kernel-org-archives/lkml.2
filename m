Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946608Ab2JDVqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:46:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59358 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946223Ab2JDVqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:46:20 -0400
MIME-Version: 1.0
In-Reply-To: <506E029E.3000102@zytor.com>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
	<1348991844-12285-5-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com>
	<CAE9FiQUMMRPb2u13R2b7hHSOTgb4jKcnbAace7T22_GCm=-HxQ@mail.gmail.com>
	<20121004164551.GA2244@phenom.dumpdata.com>
	<CAE9FiQWjXhat85JpXhCLApGe62mdCwb2HKhWGLjQdj2ed=6buA@mail.gmail.com>
	<CAE9FiQVnTqWx808F_CWaiGXT12Y4rfKPOERtSgGb=2t_4T44+A@mail.gmail.com>
	<506E029E.3000102@zytor.com>
Date: Thu, 4 Oct 2012 14:46:18 -0700
X-Google-Sender-Auth: HfXUGw-o-5Fx7sKe6cFANpxsFpU
Message-ID: <CAE9FiQWPNmsw9OMrdP7Q0JnjGv66PBkAcJQhizUm0Kji-yvw8g@mail.gmail.com>
Subject: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 2:41 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/04/2012 02:40 PM, Yinghai Lu wrote:
>> On Thu, Oct 4, 2012 at 2:21 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> On Thu, Oct 4, 2012 at 9:45 AM, Konrad Rzeszutek Wilk
>>> <konrad.wilk@oracle.com> wrote:
>>>>> So could use ram under 1M to map that page table at first.
>>>>
>>>> Could or does this patch do it? And why 1MB?
>>>
>>> can you or stefano could test attached patch on xen ?
>>>
>> on top of
>>
>> http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=shortlog;h=refs/heads/x86/mm2
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git  x86/mm2
>>
>
> No, no, not yet another ad hoc hack... please.
>

or let xen map that page table by itself at first?
