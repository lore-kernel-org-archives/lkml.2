Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806Ab2FHU2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 16:28:45 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:48612 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934249Ab2FHU2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 16:28:44 -0400
Date: Fri, 8 Jun 2012 16:28:40 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: writeback: bad unlock balance detected in 3.5-rc1
Message-ID: <20120608202840.GB1704@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Fengguang Wu <fengguang.wu@intel.com>
References: <E1Sd0IP-0005nh-AJ@tytso-glaptop.cam.corp.google.com>
 <20120608150736.GF21080@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608150736.GF21080@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 05:07:36PM +0200, Jan Kara wrote:
>   Argh, I wonder how come I didn't hit this. Does attached patch fix the
> problem?

Just to confirm (although there was little doubt), I've built a kernel
with this patch and it fixes the lockdep complaint.

     	  	       	     	 - Ted
