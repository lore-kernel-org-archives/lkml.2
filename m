Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab0HCQt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 12:49:58 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.209.12]:43580 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab0HCQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 12:49:56 -0400
X-Greylist: delayed 2280 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Aug 2010 12:49:56 EDT
Date: Tue, 3 Aug 2010 12:11:41 -0400
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, stable@kernel.org,
        Vladislav Bolkhovitin <vst@vlnb.net>,
        Bryan Mesich <bryan.mesich@ndsu.edu>, scst-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] coda: rename REQ_* to CODA_REQ_*
Message-ID: <20100803161141.GA14888@cs.cmu.edu>
Mail-Followup-To: Tejun Heo <tj@kernel.org>,
	Jens Axboe <jaxboe@fusionio.com>, stable@kernel.org,
	Vladislav Bolkhovitin <vst@vlnb.net>,
	Bryan Mesich <bryan.mesich@ndsu.edu>,
	scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, dm-devel@redhat.com,
	Neil Brown <neilb@suse.de>
References: <4C5073F3.1060406@vlnb.net>
 <4C52A98A.7060507@kernel.org>
 <20100802104227.79340b49@notabene>
 <4C56D397.8010305@kernel.org>
 <4C5724E8.9010204@kernel.dk>
 <4C57E722.5060809@kernel.org>
 <4C57FA57.2000601@kernel.dk>
 <4C57FBAD.1080809@fusionio.com>
 <4C583B3B.3060301@kernel.org>
 <4C583DAD.4080507@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C583DAD.4080507@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 06:02:53PM +0200, Tejun Heo wrote:
> REQ_* constants are used for block layer requests causing inconsistent
> duplicate definitions of REQ_WRITE.  Rename REQ_* used by coda to
> CODA_REQ_*.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Looks good to me.

Acked-by: Jan Harkes <jaharkes@cs.cmu.edu>

