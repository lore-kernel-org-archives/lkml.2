Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291Ab1FPOZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:25:51 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35984
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758220Ab1FPOZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:25:49 -0400
Date: Thu, 16 Jun 2011 10:25:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [media] DocBook: Use base64 for gif/png files
Message-ID: <20110616142545.GA5785@infradead.org>
References: <4DFA0FF7.1030400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFA0FF7.1030400@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 11:15:19AM -0300, Mauro Carvalho Chehab wrote:
> The patch utility doesn't work with non-binary files. This causes some
> tools to break, like generating tarball targets and the scripts that
> generate diff patches at http://www.kernel.org/pub/linux/kernel/v2.6/.
> 
> So, let's convert all binaries to ascii using base64, and add a
> logic at Makefile to convert them back into binaries at runtime.

Given that all the gifs are not just relatively trivial, but also things
that looks like they originated or at least should as vector graphics
I'd recommend to replace them by SVG files.  These also have the benefit
of actually beeing practically patchable.

