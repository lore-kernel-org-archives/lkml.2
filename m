Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab1BIS3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 13:29:32 -0500
Received: from smtp.scorch.co.nz ([27.110.127.199]:50954 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754981Ab1BIS3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 13:29:31 -0500
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Date: Thu, 10 Feb 2011 07:22:47 +1300
User-Agent: KMail/1.9.10
Cc: Charles Manning <cdhmanning@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ryan@bluewatersys.com,
        akpm@linux-foundation.org
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <20110209045221.GB29650@infradead.org>
In-Reply-To: <20110209045221.GB29650@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102100722.47854.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 February 2011 17:52:21 Christoph Hellwig wrote:
> On Wed, Feb 09, 2011 at 04:25:58PM +1300, Charles Manning wrote:
> > Comments/feedback welcome, but I'm hopefully getting pretty close to
> > acceptance :-).
>
> It's not anywhere near ready as long as you insist keeping that silly
> Linux glue code.  

Can you be a bit more specific?

Did you actually look or did you just get hives when you saw "glue code"? The 
current glue code is very far from what was in the original patch set. In the 
first set there were all sorts of abstractions which have been purged and 
almost entirely removed.

The current "glue code" really just partitions off the vfs interaction from 
the file system internal operations.

This partitioning serves a purpose: it allows the code to be easily integrated 
into applications etc (ie outside of the kernel) and also allows the 
multi-version code to be supported more cleanly. Multi-version is incredibly 
important in the RealWorld (TM).

> Also make sure it passes the xfstests QA suite 
> (http://git.kernel.org/?p=fs/xfs/xfstests-dev.git;a=summary), which
> might need a bit work to be made run depending on how quirky your
> mkfs/fsck tools are.

Thanks. I'll try those.

It does pass fsx and some other tests.

-- Charles




