Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1AVOyN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 09:54:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab1AVOyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 09:54:11 -0500
Date: Sat, 22 Jan 2011 15:54:09 +0100
From: Michal Marek <mmarek@suse.cz>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Tony Finch <dot@dotat.at>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] unifdef: update to upstream version 2.5
Message-ID: <20110122145409.GA1499@sepie.suse.cz>
References: <E1PfI64-00041z-0d@hermes-1.csi.cam.ac.uk>
 <20110119043605.GA9903@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110119043605.GA9903@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 12:36:05PM +0800, Américo Wang wrote:
> On Tue, Jan 18, 2011 at 08:12:49PM +0000, Tony Finch wrote:
> >Fix a long-standing cpp compatibility bug. The -DFOO argument
> >(without an explicit value) should define FOO to 1 not to the empty
> >string.
> >
> >Add a -o option to support overwriting a file in place, and a -S
> >option to list the nesting depth of symbols. Include line numbers
> >in debugging output. Support CRLF newlines.
> >
> 
> Could you split the patch? It is hard for review.

None of the changes affect the way unifdef is used in the kernel build,
so I happily applied the patch to kbuild-2.6.git#kbuild.

Thanks,
Michal
