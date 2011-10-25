Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab1JYJme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:42:34 -0400
Received: from verein.lst.de ([213.95.11.211]:55298 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab1JYJmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:42:33 -0400
Date: Tue, 25 Oct 2011 11:42:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Roland Dreier <roland@purestorage.com>
Subject: Re: [GIT PULL] target: Updates for v3.2-rc1 (round one)
Message-ID: <20111025094232.GA17763@lst.de>
References: <1319533236.17450.338.camel@haakon2.linux-iscsi.org> <CA+55aFyeCfXV9Fpg9vZywmHtP3PR8+voZpampVqW8TAfCvLv3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyeCfXV9Fpg9vZywmHtP3PR8+voZpampVqW8TAfCvLv3Q@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 11:29:39AM +0200, Linus Torvalds wrote:
> On Tue, Oct 25, 2011 at 11:00 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > ?36 files changed, 937 insertions(+), 2068 deletions(-)
> 
> Hmm. This is not what I get. It might be a git version issue or diff
> algorithm one - although that's actually pretty unusual. Do you do
> something odd/special?

It's mostly me looking at the code and factoring code and removing
unneeded things from old versions.

