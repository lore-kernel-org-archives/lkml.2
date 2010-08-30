Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab0H3KFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:05:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab0H3KE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:04:58 -0400
Message-ID: <4C7B8248.5070602@suse.de>
Date: Mon, 30 Aug 2010 12:04:56 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <jaxboe@fusionio.com>, Ric Wheeler <rwheeler@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "chris.mason@oracle.com" <chris.mason@oracle.com>,
        "swhiteho@redhat.com" <swhiteho@redhat.com>,
        "konishi.ryusuke@lab.ntt.co.jp" <konishi.ryusuke@lab.ntt.co.jp>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "vst@vlnb.net" <vst@vlnb.net>, "jack@suse.cz" <jack@suse.cz>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100820132214.GA6184@lst.de> <4C6E9CAF.5010202@redhat.com> <4C7269E9.9070304@kernel.org> <20100823124815.GA20095@lst.de> <4C727E96.5020801@redhat.com> <4C727F2B.6060501@fusionio.com> <20100823140823.GA23490@lst.de>
In-Reply-To: <20100823140823.GA23490@lst.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Aug 23, 2010 at 04:01:15PM +0200, Jens Axboe wrote:
>> The problem purely exists on arrays that report write back cache enabled
>> AND don't implement SYNC_CACHE as a noop. Do any of them exist, or are
>> they purely urban legend?
> 
> I haven't seen it.  I don't care particularly about this case, but once
> it a while people want to disable flushing for testing or because they
> really don't care.
> 
aacraid for one falls into this category.
SYNC_CACHE is no-oped in the driver. Otherwise you get a _HUGE_
performance loss.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
