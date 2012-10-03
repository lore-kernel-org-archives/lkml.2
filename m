Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab2JCNNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:13:17 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61931 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab2JCNNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:13:16 -0400
MIME-Version: 1.0
In-Reply-To: <506B3AC2.2090108@zytor.com>
References: <20121001161151.GA2640@darkstar>
	<20121001162745.GD23181@x1.osrc.amd.com>
	<506A8479.8030103@zytor.com>
	<CACJDEmpXHoOYK-8F3a4nQi5GELnRSmdmWdU=i9PkNuxGcyjZRg@mail.gmail.com>
	<506B3AC2.2090108@zytor.com>
Date: Wed, 3 Oct 2012 09:13:16 -0400
X-Google-Sender-Auth: NQVhOoxtHCu5W4jJj0BDHhapzhE
Message-ID: <CACJDEmqNGsigBBktbnptbv3G5VD98F3htfwhx9mVCvz6mRQ0oQ@mail.gmail.com>
Subject: Re: [PATCH 00/11] x86/microcode: Early load microcode
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Jamie Gloudon <jamie.gloudon@gmail.com>,
        fenghua.yu@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 3:04 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/02/2012 12:00 PM, Konrad Rzeszutek Wilk wrote:
>>
>> When he got interrupted did he have any beta patches to dracut that
>> could be posted?
>>
>
> To *dracut*?

The replacement for mkinitrd. You know the thing that creates your
initramfs.cpio.gz.
