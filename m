Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab0JYU6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 16:58:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34503 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab0JYU6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 16:58:17 -0400
Date: Mon, 25 Oct 2010 16:57:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "J.H." <warthog9@kernel.org>, John Stoffel <john@stoffel.org>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, david@fromorbit.com,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 01/11] IMA: use rbtree instead of radix tree for inode
 information cache
Message-ID: <20101025205746.GA6568@infradead.org>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
 <19653.55494.240658.165153@quad.stoffel.home>
 <4CC5DCBB.1070505@kernel.org>
 <AANLkTim5-QDaG3G_8hq3k83csWsdM-4Pt7V92WtmVx3i@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim5-QDaG3G_8hq3k83csWsdM-4Pt7V92WtmVx3i@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 01:55:09PM -0700, Linus Torvalds wrote:
> Please do feel free to be constructive about it, and I'm sure there
> are ways to improve even more, but right now "constructive" is not
> what the objections seem to be.

Kyle sent a very useful patch to simply disable the ima tracking unless
you enable it on the command line.

