Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab2JVRoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:44:01 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58738 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab2JVRn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:43:59 -0400
MIME-Version: 1.0
In-Reply-To: <20121022143312.GE14193@konrad-lan.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-8-git-send-email-yinghai@kernel.org>
	<20121022143312.GE14193@konrad-lan.dumpdata.com>
Date: Mon, 22 Oct 2012 10:43:57 -0700
X-Google-Sender-Auth: XKzoJyi-7336Meyai3BXHSpqbrU
Message-ID: <CAE9FiQWEhfOPOqSQLK9rkjvJw+wEoBYKGiKTFdeXqt8jrF=jCQ@mail.gmail.com>
Subject: Re: [PATCH 04/19] x86, mm: only keep initial mapping for ram
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

On Mon, Oct 22, 2012 at 7:33 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
> On Thu, Oct 18, 2012 at 01:50:15PM -0700, Yinghai Lu wrote:
>> 0 mean any e820 type, for any range is overlapped with any entry in e820,
>> kernel will keep it's initial page table mapping.
>>
>> What we want is only keeping initial page table for ram range.
>
> Can you squash it in the previous patch then pls? It seems like
> this is a bug-fix to a bug-fix. And since this patchset is still
> out-side the Linus's tree you have the option of squashing/rebasing.

ok.
