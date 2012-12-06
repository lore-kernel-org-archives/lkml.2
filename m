Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423223Ab2LFMGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 07:06:48 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55078
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323Ab2LFMGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 07:06:46 -0500
Date: Thu, 6 Dec 2012 07:06:45 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121206120645.GB14100@infradead.org>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <201212051148.28039.Martin@lichtvoll.de>
 <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <201212051718.44017.Martin@lichtvoll.de>
 <CA+55aFxsPBo4TZEPq+14NBE8Snmd9qiTjAiEP0fFXBzaJ9y+gw@mail.gmail.com>
 <20121206011402.GB27172@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206011402.GB27172@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 12:14:02PM +1100, Dave Chinner wrote:
> On Wed, Dec 05, 2012 at 10:25:17AM -0800, Linus Torvalds wrote:
> > Yes, people can argue that "process" is about technical issues too,
> > but let's be honest: our process is fluid. Not everything gets
> > reviewed on the mailing list, and people *do* talk about things
> > face-to-face at conferences.
> 
> Yes, that is true.
> 
> But we don't review code at conferences. We have mailing lists for
> that.  I've lost count of the number of times I've heard "post your
> code" or "let's take it to the list" or "better to discuss this on
> the list where everyone can comment" at conferences such as
> Plumbers. It's a standard practise - talk at conferences, review
> on mailing lists.

Also the only conference outcome I remember is that everyone at LSF
except for Ted basically said "no fucking way".

