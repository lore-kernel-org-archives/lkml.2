Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031059Ab2CVRBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:01:32 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44445
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023Ab2CVRB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:01:29 -0400
Date: Thu, 22 Mar 2012 13:01:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Ted Ts'o" <tytso@mit.edu>, Risanecek <risanecek@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: ext2 large block size support - the shocking truth...
Message-ID: <20120322170127.GA11819@infradead.org>
References: <CAE7SGk7rJXwjs4pD01e_ZgkoH4UNLAh8JLfX1_gv=q7RXtY5Gw@mail.gmail.com>
 <20120321212152.GA32041@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321212152.GA32041@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 05:21:52PM -0400, Ted Ts'o wrote:
> It's not an enhanced ext2 as much as it is enhancements primarily in
> the mm layer to allow file systems to use a "larger page" which is
> larger than the native page size of the CPU's MMU.  This is the first
> that I've heard of a DVR, or any product in general, actually trying
> to use Christoph Lameter's patches in a shipping Linux system.
> 
> If you just need to read and write files from this file system from a
> userspace CLI shell utility, you could just use the programs from the
> e2tools package; they should work just fine.  It works much like the
> mtools package do to be able to copy, rename, list directories, of an
> MSDOS file system, but for ext2/3/4 file systems.
> 
> Alternatively, you could try to forward port Christoph's patches to a
> modern kernel, or commission someone to port it to a modern for you...

Or the device might have a CPU with larger pages.  I've seen various
appliances with ppc CPUs that use 64k page and for special applications
even 256k pages.  I've also seen XFS and extN filesystem taking
"advantage" of that (not sure if really helped them with their
workloads, or if they did it just because they could)

