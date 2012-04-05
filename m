Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab2DEQkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:40:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab2DEQkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:40:21 -0400
Date: Thu, 5 Apr 2012 18:40:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cleanup of rw_copy_check_uvector and
	compat_rw_copy_check_uvector
Message-ID: <20120405164003.GA25667@redhat.com>
References: <20120130145114.4c084a6a@Gantu.yeoh.info> <20120130172337.GA12696@redhat.com> <20120130140128.037aca27.akpm@linux-foundation.org> <20120201123422.57af1859@Gantu.yeoh.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120201123422.57af1859@Gantu.yeoh.info>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01, Christopher Yeoh wrote:
>
> On Mon, 30 Jan 2012 14:01:28 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Yes please.  Put oneself in the position of a developer reading the
> > changelog two years from now.
> >
> > Also, please use our conventional comment layout style in fs.h.
>
> Updated changelog and patch below. Differences from last patch

Looks like this (imho good) cleanup was forgotten.

Christopher, perhaps you can re-send?

Oleg.

