Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab0HWQtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:49:31 -0400
Received: from hole.yuiop.co.uk ([89.145.97.62]:56538 "EHLO mail.yuiop.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab0HWQta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:49:30 -0400
X-Greylist: delayed 1262 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Aug 2010 12:49:29 EDT
Message-ID: <4C72A1A3.3080806@anonymous.org.uk>
Date: Mon, 23 Aug 2010 17:28:19 +0100
From: John Robinson <john.robinson@anonymous.org.uk>
Organization: None; Disorganization: Total
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.24) Gecko/20100228 Lightning/0.9 Thunderbird/2.0.0.24 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu,
        chris.mason@oracle.com, swhiteho@redhat.com,
        konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net,
        jack@suse.cz, rwheeler@redhat.com, hare@suse.de
Subject: OT grammar nit Re: [PATCH] block: simplify queue_next_fseq
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100823141512.GA23771@lst.de>
In-Reply-To: <20100823141512.GA23771@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/08/2010 15:15, Christoph Hellwig wrote:
> We need to call blk_rq_init and elv_insert for all cases in queue_next_fseq,
> so take these calls into common code.  Also move the end_io initialization
> from queue_flush into queue_next_fseq and rename queue_flush to
> init_flush_request now that it's old name doesn't apply anymore.

Nit: it's "its" above, not "it's". If in doubt, if it's "it is" (or "it 
has") it's "it's" but if it could be "his" or "hers" it's "its".

I'm guessing English isn't your first language (a) because of your .de 
address and (b) because it's better than most British people's, but 
still, it's a common mistake. If I can remember any of the German I 
studied all those years ago, "its" is roughly equivalent to "sein", and 
"it's" to "es ist".

Cheers,

John.
