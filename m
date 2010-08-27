Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab0H0JYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:24:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:42015 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab0H0JYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:24:32 -0400
Message-ID: <4C7782D1.5040501@kernel.org>
Date: Fri, 27 Aug 2010 11:18:09 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com
Subject: Re: [PATCH] block: update documentation for REQ_FLUSH / REQ_FUA
References: <1282751267-3530-1-git-send-email-tj@kernel.org> <20100826095413.GA9750@lst.de>
In-Reply-To: <20100826095413.GA9750@lst.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 27 Aug 2010 09:24:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2010 11:54 AM, Christoph Hellwig wrote:
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

applied to misc#flush-fua.

Thanks.

-- 
tejun
