Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab2GFNPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:15:36 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57170 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab2GFNPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:15:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120705141700.GI3399@mudshark.cambridge.arm.com>
References: <1341412376-6272-1-git-send-email-will.deacon@arm.com>
	<CAJd=RBAmF3dtb8wtEbS-A7BNT=RLsb5emQQWVU8ioeQOO8D7NA@mail.gmail.com>
	<20120705141700.GI3399@mudshark.cambridge.arm.com>
Date: Fri, 6 Jul 2012 21:15:34 +0800
Message-ID: <CAJd=RBC+foz61E733P8jkkwPqAkdFjYc_9uYza67Z=n3=7bv-A@mail.gmail.com>
Subject: Re: [PATCH] mm: hugetlb: flush dcache before returning zeroed huge
 page to userspace
From: Hillf Danton <dhillf@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 10:17 PM, Will Deacon <will.deacon@arm.com> wrote:
>
> Which tree does this stuff usually go through?

mm --> next --> linus
