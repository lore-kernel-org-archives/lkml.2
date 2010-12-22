Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab0LVUjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 15:39:17 -0500
Received: from straum.hexapodia.org ([207.7.131.186]:47200 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0LVUjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 15:39:15 -0500
Date: Wed, 22 Dec 2010 12:39:15 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: btrfs: 21 minutes to read 1.2M file directory
Message-ID: <20101222203915.GA9918@hexapodia.org>
References: <20101220222446.GA8629@hexapodia.org> <AANLkTikjuoiCJvbBTLuyh3-d=QRyVVdatc4Ybcx5UOdf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikjuoiCJvbBTLuyh3-d=QRyVVdatc4Ybcx5UOdf@mail.gmail.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 03:07:33AM +0200, Felipe Contreras wrote:
> On Tue, Dec 21, 2010 at 12:24 AM, Andy Isaacson <adi@hexapodia.org> wrote:
> > I have a directory with 1.2M files in it, which makes readdir very slow
> > on btrfs with cold caches (although it's reasonably fast with hot caches
> > as in the first example below):
> 
> Sounds like:
> 
> Bug 21562 - btrfs is dead slow due to fragmentation
> https://bugzilla.kernel.org/show_bug.cgi?id=21562

Hmmm, how do I look at the btree layout for a given inode?

btrfs-image for this filesystem is 1.7GiB .bz2, so I'm afraid it's not
reasonable to publish it.

-andy
