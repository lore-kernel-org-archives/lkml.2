Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934318Ab0HMNC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:02:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49660 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934276Ab0HMNCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:02:24 -0400
Message-ID: <4C654100.3060307@vlnb.net>
Date: Fri, 13 Aug 2010 16:56:32 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, jack@suse.cz, rwheeler@redhat.com, hare@suse.de,
        Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 02/11] block: kill QUEUE_ORDERED_BY_TAG
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <1281616891-5691-3-git-send-email-tj@kernel.org>
In-Reply-To: <1281616891-5691-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:bLG0yymJNm4qTbpIgfAg+NxiWsk4bcOoBTJB4Bh6AVJ
 bXnnjQ0g8ex+ji0oZ5eXS4YyohgcvCc9C4xyQ/8ZWrjyeyrxM4
 tPcRvaIUcschR83R7Hqqsdi/3vqGzVBSXn/lnGI2RUr83g/bRL
 gAXFQB9Wf3CMW2OChGqk++BTqPEWUOCqv2T+BKCP022AnZ2efz
 95nzUc1s7gooflABGCuFw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

Tejun Heo, on 08/12/2010 04:41 PM wrote:
> Nobody is making meaningful use of ORDERED_BY_TAG now and queue
> draining for barrier requests will be removed soon which will render
> the advantage of tag ordering moot.

Have you seen Hannes Reinecke's and my measurements in 
http://marc.info/?l=linux-scsi&m=128110662528485&w=2 and 
http://marc.info/?l=linux-scsi&m=128111995217405&w=2 correspondingly?

If yes, what else evidences do you need to see that the tag ordering is 
a big performance win?

Vlad
