Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab1KUKG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:06:28 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39161
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157Ab1KUKG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:06:27 -0500
Date: Mon, 21 Nov 2011 05:06:22 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Christoph Hellwig <hch@infradead.org>, Cong Wang <amwang@redhat.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Pekka Enberg <penberg@kernel.org>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [V2 PATCH] tmpfs: add fallocate support
Message-ID: <20111121100622.GA17887@infradead.org>
References: <1321612791-4764-1-git-send-email-amwang@redhat.com>
 <20111119100326.GA27967@infradead.org>
 <CAPXgP10q8Fba3vr0zf-XBBaRPwjP7MyJ=-QRL45_8WC-vtotOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP10q8Fba3vr0zf-XBBaRPwjP7MyJ=-QRL45_8WC-vtotOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 03:14:48PM +0100, Kay Sievers wrote:
> On Sat, Nov 19, 2011 at 11:03, Christoph Hellwig <hch@infradead.org> wrote:
> > On Fri, Nov 18, 2011 at 06:39:50PM +0800, Cong Wang wrote:
> >> It seems that systemd needs tmpfs to support fallocate,
> >> see http://lkml.org/lkml/2011/10/20/275. This patch adds
> >> fallocate support to tmpfs.
> >
> > What for exactly? ??Please explain why preallocating on tmpfs would
> > make any sense.
> 
> To be able to safely use mmap(), regarding SIGBUS, on files on the
> /dev/shm filesystem. The glibc fallback loop for -ENOSYS on fallocate
> is just ugly.

That is the kind of information which needs to be in the changelog.

