Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab2BAIo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 03:44:59 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:45529 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753710Ab2BAIo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 03:44:58 -0500
MIME-Version: 1.0
In-Reply-To: <20120201083032.GA6774@localhost>
References: <20120201063420.GA10204@darkstar.nay.redhat.com>
	<CAOJsxLGVS3bK=hiKJu4NwTv-Nf8TCSAEL4reSZoY4=44hPt8rA@mail.gmail.com>
	<4F28EC9D.7000907@redhat.com>
	<20120201083032.GA6774@localhost>
Date: Wed, 1 Feb 2012 10:44:58 +0200
X-Google-Sender-Auth: GG01YzTZFEyfJVKwpRN4wEn4n7c
Message-ID: <CAOJsxLEnn-5X5q=1p07twxm5EuyQo7cOBBfFQXUeMGi3Pvd46w@mail.gmail.com>
Subject: Re: [PATCH] move vm tools from Documentation/vm/ to tools/
From: Pekka Enberg <penberg@kernel.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 10:30 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> Will git-mv end up with a better commit?

Just use

    git format-patch -C

to generate the patch and it should be fine.

>> BTW, I think tools/slub/slabinfo.c should be included in tools/vm/ as
>> well, will move it in v2 patch
>
> CC Christoph. Maybe not a big deal since it's already under tools/.

I'm certainly fine with moving it to tools/vm.
