Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab1DVL25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 07:28:57 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:54936 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab1DVL2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 07:28:54 -0400
Date: Fri, 22 Apr 2011 13:28:52 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Josef Bacik <josef@toxicpanda.com>, Eric Blake <eblake@redhat.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Message-ID: <20110422112852.GB1627@x4.trippels.de>
References: <1303414954-3315-1-git-send-email-josef@redhat.com>
 <loom.20110422T001650-760@post.gmane.org>
 <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com>
 <20110422045054.GB17795@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110422045054.GB17795@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.04.22 at 00:50 -0400, Christoph Hellwig wrote:
> [Eric: please don't drop the Cc list, thanks!]
> 
> On Thu, Apr 21, 2011 at 09:22:55PM -0400, Josef Bacik wrote:
> > > since all files have a virtual hole at the end, but leaves the position
> > > unchanged). ??I'd have to write a test program on Solaris to see whether that
> > > definition is actually true, or if it is a bug in the Solaris man page.
> > >
> > 
> > lseek's purpose is to reposition the file position, so I'd imagine
> > this is just a bug in the man page.
> 
> I would be surprised if the bug is around for such a long time, but
> otherwise I concur.

It's a bug. Let me quote what Jeff Bonwick wrote on his blog:

»I'm not sure where you got the impression that either SEEK_HOLE or
SEEK_DATA doesn't set the file pointer. They do. (If they didn't, that
would be weird, and we'd call it out explicitly.)«

http://blogs.sun.com/bonwick/entry/seek_hole_and_seek_data

-- 
Markus
