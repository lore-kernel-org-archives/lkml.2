Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1BEQYx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 11:24:53 -0500
Received: from kroah.org ([198.145.64.141]:60952 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab1BEQYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 11:24:51 -0500
Date: Sat, 5 Feb 2011 08:20:18 -0800
From: Greg KH <greg@kroah.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        axboe@kernel.dk, tytso@mit.edu, shli@kernel.org, neilb@suse.de,
        adilger.kernel@dilger.ca, jack@suse.cz, snitzer@redhat.com,
        linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
        linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
        josef@redhat.com
Subject: Re: [PATCH 1/3] block: Create sysfs knobs to override FLUSH/FUA
 support flags
Message-ID: <20110205162018.GA22782@kroah.com>
References: <20110126071200.GE32261@tux1.beaverton.ibm.com>
 <20110126071626.GI27190@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126071626.GI27190@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 11:16:26PM -0800, Darrick J. Wong wrote:
> This patch is the first in a series to refactor the barrier= mount options out
> of the filesystem code.  This patch adds sysfs knobs to disable flush and FUA;

If you add sysfs files, you must also add documentation for these files
in Documentation/ABI/.

Please do that in this patch series.

thanks,

greg k-h
