Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab1CAATt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 19:19:49 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46066 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591Ab1CAATr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 19:19:47 -0500
Subject: Re: [PATCH 0/5] target updates for scsi-post-merge .39 (round one,
 v2)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Joel Becker <jlbec@evilplan.org>,
        Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <1298938651-18784-1-git-send-email-nab@linux-iscsi.org>
References: <1298938651-18784-1-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 18:19:44 -0600
Message-ID: <1298938784.2487.72.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 16:17 -0800, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hi James and Co,
> 
> The following is the first round (v2) of target patches intended for .39
> scsi-post-merge tree that introduces new target functionality and the
> first mainline TCM fabric module (TCM_Loop).

OK, what postmerge tree?  There haven't been any conflicts this merge
cycle that necessitate running one.  Do you mean you want these after
the merge window for some reason?

James


