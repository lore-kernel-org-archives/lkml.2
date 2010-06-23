Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0FWXkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 19:40:39 -0400
Received: from mail2.shareable.org ([80.68.89.115]:45792 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab0FWXkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 19:40:37 -0400
Date: Thu, 24 Jun 2010 00:40:31 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Edward Shishkin <edward.shishkin@gmail.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, Mat <jackdachef@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, Ric Wheeler <rwheeler@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       The development of BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs: broken file system design (was Unbound(?) internal 	fragmentation in Btrfs)
Message-ID: <20100623234031.GF7058@shareable.org>
References: <4C07C321.8010000@redhat.com> <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com> <4C1B7560.1000806@gmail.com> <AANLkTilQm8VGAvc1XNW4EaHd1FLd6dXIXwJ9-yT-joQ8@mail.gmail.com> <4C1BA3E5.7020400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1BA3E5.7020400@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Edward Shishkin wrote:
> I have noticed that events in Btrfs develop by scenario not predicted
> by the paper of academic Ohad Rodeh (in spite of the announce that
> Btrfs is based on this paper). This is why I have started to grumble..

In btrfs, "based on" means "started with the algorithm and ideas of",
not "uses the same algorithm as".

-- Jamie
