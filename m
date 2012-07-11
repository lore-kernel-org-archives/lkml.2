Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab2GKS4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 14:56:12 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:46842 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab2GKS4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 14:56:09 -0400
Date: Wed, 11 Jul 2012 11:55:34 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Cong Wang <xiyou.wangcong@gmail.com>
cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] tmpfs: revert SEEK_DATA and SEEK_HOLE
In-Reply-To: <jtj574$tb7$2@dough.gmane.org>
Message-ID: <alpine.LSU.2.00.1207111149580.1797@eggly.anvils>
References: <alpine.LSU.2.00.1207091533001.2051@eggly.anvils> <alpine.LSU.2.00.1207091535480.2051@eggly.anvils> <jtj574$tb7$2@dough.gmane.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012, Cong Wang wrote:
> On Mon, 09 Jul 2012 at 22:41 GMT, Hugh Dickins <hughd@google.com> wrote:
> > Revert 4fb5ef089b28 ("tmpfs: support SEEK_DATA and SEEK_HOLE").
> > I believe it's correct, and it's been nice to have from rc1 to rc6;
> > but as the original commit said:
> >
> > I don't know who actually uses SEEK_DATA or SEEK_HOLE, and whether it
> > would be of any use to them on tmpfs.  This code adds 92 lines and 752
> > bytes on x86_64 - is that bloat or worthwhile?
> 
> 
> I don't think 752 bytes matter much, especially for x86_64.
> 
> >
> > Nobody asked for it, so I conclude that it's bloat: let's revert tmpfs
> > to the dumb generic support for v3.5.  We can always reinstate it later
> > if useful, and anyone needing it in a hurry can just get it out of git.
> >
> 
> If you don't have burden to maintain it, I'd prefer to leave as it is,
> I don't think 752-bytes is the reason we revert it.

Thank you, your vote has been counted ;)
and I'll be glad if yours stimulates some agreement or disagreement.

But your vote would count for a lot more if you know of some app which
would really benefit from this functionality in tmpfs: I've heard of none.

Hugh
