Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab2KAKct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 06:32:49 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52534 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab2KAKcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 06:32:48 -0400
X-AuditID: b753bd60-90ac1ba0000047ca-31-50924fcd9afd
Message-ID: <50924FCD.2020100@hitachi.com>
Date: Thu, 01 Nov 2012 19:32:45 +0900
From: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Patch 0/2] Exclude hwpoison page from vmcore dump
References: <508FDEF3.8030601@hitachi.com> <20121030143750.GF2290@redhat.com> <50912CFB.5000508@hitachi.com> <20121031141426.GE1865@redhat.com>
In-Reply-To: <20121031141426.GE1865@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

(2012/10/31 23:14), Vivek Goyal wrote:
> If hwpoision functionality is not available in hardware, then respective
> bit will not be even set in struct page and it will be saved by default.
> So it should not matter whether hardware has hwpoision functionality
> or not.

Thanks, I understand.

> I think that removing hwpoisno pages by default makes sense. If somebody
> does have a reasonable case of not doing so, then we could either
> introduce anther filtering level (based on type) or add another command
> line option like (--no-hwposion-filtering) etc.

I agree with you.
If somebody requests to support for disabling the filter of hwpoison pages,
this option will be discussed.

Regards,
Mitshuhiro Tanino (mitsuhiro.tanino.gm@hitachi.com)

