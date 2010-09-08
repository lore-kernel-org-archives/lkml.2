Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab0IHQM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 12:12:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:43195 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892Ab0IHQMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 12:12:23 -0400
Message-ID: <4C87B5E2.6070207@suse.de>
Date: Wed, 08 Sep 2010 18:12:18 +0200
From: Tejun Heo <teheo@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com, mpatocka@redhat.com
Subject: Re: [PATCHSET #upstream] block, fs: replace HARDBARRIER with FLUSH/FUA,
 take#2
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

I added Mike's cleanup patch and Kiyoshi's Tested-by and updated
flush-fua branch accordingly.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git flush-fua

I guess it's about ready.  Please consider pulling it into the block
tree so that it can get linux-next exposure.  If you want the whole
patch series resent, please let me know.

Thanks.

-- 
tejun
