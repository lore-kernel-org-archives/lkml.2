Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1CAMPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 07:15:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47737 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1CAMPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 07:15:33 -0500
Date: Tue, 1 Mar 2011 12:15:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: Josh Hunt <johunt@akamai.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "sandeen@redhat.com" <sandeen@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC][PATCH] ext2: Resolve i_nlink race in ext2_rename
Message-ID: <20110301121530.GH22723@ZenIV.linux.org.uk>
References: <1298528501-32176-1-git-send-email-johunt@akamai.com>
 <20110224063749.GV22723@ZenIV.linux.org.uk>
 <20110224112010.GB23042@quack.suse.cz>
 <4D66BD18.2030207@akamai.com>
 <20110228175734.GC20805@quack.suse.cz>
 <4D6C02F3.7070209@akamai.com>
 <20110228205652.GH20805@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110228205652.GH20805@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 09:56:52PM +0100, Jan Kara wrote:
> On Mon 28-02-11 12:17:55, Josh Hunt wrote:
> > On 02/28/2011 09:57 AM, Jan Kara wrote:
> > > So I took your patch and used a changelog from mine as I find it more
> > > descriptive. The resulting patch is in my tree (and attached).
> > > 
> > > 								Honza
> > Jan
> > 
> > Thanks. We should probably send this to the stable guys as well.
>   Good point. Made sure they are warned when the patch gets in.

I have an equivalent of that for other affected fs in my tree; will go
to Linus in an hour or so.
