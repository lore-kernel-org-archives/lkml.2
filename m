Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0H3T7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 15:59:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab0H3T7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 15:59:38 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>,
        jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, rwheeler@redhat.com, hare@suse.de,
        neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, jeremy@goop.org,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 26/30] ext4: do not send discards as barriers
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
	<1282751267-3530-27-git-send-email-tj@kernel.org>
	<20100825155842.GA3229@lst.de> <20100825160032.GC3229@lst.de>
	<4C753D75.2010305@kernel.org> <20100825200223.GE2738@quack.suse.cz>
	<4C76250B.6060800@kernel.org> <20100827173147.GA12374@quack.suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 30 Aug 2010 15:56:43 -0400
In-Reply-To: <20100827173147.GA12374@quack.suse.cz> (Jan Kara's message of
	"Fri, 27 Aug 2010 19:31:48 +0200")
Message-ID: <x4939tv98n8.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>   An update: I've set up an ext4 barrier testing in KVM - run fsstress,
> kill KVM at some random moment and check that the filesystem is consistent
> (kvm is run in cache=writeback mode to simulate disk cache). About 70 runs

But doesn't your "disk cache" survive the "power cycle" of your guest?
It's tough to tell exactly what you're testing with so few details;
care to elaborate?

Cheers,
Jeff
