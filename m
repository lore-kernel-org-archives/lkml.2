Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab2E3TEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:04:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59780 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2E3TEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:04:12 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205301328550.31768@router.home>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com>
 <CA+55aFzoVQ29C-AZYx=G62LErK+7HuTCpZhvovoyS0_KTGGZQg@mail.gmail.com> <alpine.DEB.2.00.1205301328550.31768@router.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 May 2012 12:03:50 -0700
X-Google-Sender-Auth: GpyICsO0HDjVwnjq-9Rn__vIdcU
Message-ID: <CA+55aFztNx+pzmEtEDanuvT7mx5=csAQ_pUXzMJHG1yyu81Tzg@mail.gmail.com>
Subject: Re: [PATCH 0/6] mempolicy memory corruption fixlet
To: Christoph Lameter <cl@linux.com>
Cc: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@google.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        stable@vger.kernel.org, hughd@google.com, sivanich@sgi.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, andi@firstfloor.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 11:34 AM, Christoph Lameter <cl@linux.com> wrote:
>
> Well shm support needs memory policies to spread data across nodes etc.
> AFAICT support was put in due to requirements to support large database
> vendors (oracle). Andi?
>
> Its not going to be easy to remove.

Ok. So can the people involved with this please review this patch-set
and comment on this one? I think it needs a bit of language editing
for the commit commentary, and I'd like it to see a *lot * of ack's
from the relevant vm people.

Please?

                      Linus
