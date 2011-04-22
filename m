Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1DVDXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 23:23:54 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:37997 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab1DVDXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 23:23:53 -0400
Date: Thu, 21 Apr 2011 21:23:50 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Message-ID: <20110422032350.GF31296@parisc-linux.org>
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <EB7F482C-0195-4C63-9436-17B417C8DCD7@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EB7F482C-0195-4C63-9436-17B417C8DCD7@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 04:45:54PM -0400, Theodore Tso wrote:
> 
> On Apr 21, 2011, at 3:42 PM, Josef Bacik wrote:
> 
> > +	case SEEK_DATA:
> > +	case SEEK_HOLE:
> > +		return -EINVAL;
> > 	}
> 
> Maybe we should be returning EOPNOTSUPP?

That's definitely wrong ... -ENOSYS might be better!

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
