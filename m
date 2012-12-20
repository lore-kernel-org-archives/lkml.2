Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab2LTFro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 00:47:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab2LTFri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 00:47:38 -0500
Date: Thu, 20 Dec 2012 00:47:26 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Milan Broz <mbroz@redhat.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kernel Team <kernel-team@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, jgarzik@redhat.com,
        JBottomley@Parallels.com, dm-devel@redhat.com
Subject: Re: dm-crypt: never use write same (was Re: [v3.7 Regression] [SCSI]
 sd: Implement support for WRITE SAME)
Message-ID: <20121220054725.GA17619@redhat.com>
References: <50CB8C74.3090102@canonical.com>
 <yq11uesdzya.fsf@sermon.lab.mkp.net>
 <50D0C971.1000907@canonical.com>
 <yq1bodq7zdv.fsf@sermon.lab.mkp.net>
 <20121219195801.GA14456@redhat.com>
 <50D22766.9090107@redhat.com>
 <50D22C7F.2020201@redhat.com>
 <yq1mwx960ri.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1mwx960ri.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19 2012 at  7:11pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Milan" == Milan Broz <mbroz@redhat.com> writes:
> 
> Milan> dm-crypt: never use write same
> 
> Milan> Ciphertext device is not compatible with WRITE SAME, disable it
> Milan> for all dmcrypt devices.
> 
> Milan> Signed-off-by: Milan Broz <mbroz@redhat.com>
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

I've developed more comprehensive WRITE SAME support for DM.  It can be
used in conjunction with Milan's patch (which enables Milan's patch to
go in too and be more easily tagged for v3.7 stable).

Anyway, my changes are available in the 'dm-write-same' branch of my
github tree: git://github.com/snitm/linux.git

See the top 5 commits: https://github.com/snitm/linux/commits/dm-write-same
(topmost needs to be folded, I'll do that when posting to dm-devel in
reply to this mail)
