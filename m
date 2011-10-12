Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab1JLDJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 23:09:54 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:60004 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab1JLDJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 23:09:52 -0400
Date: Tue, 11 Oct 2011 23:09:50 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        adilger.kernel@dilger.ca
Subject: Re: [PATCH] ext4/fsync.c: functions should not be declared extern
Message-ID: <20111012030950.GE11548@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	H Hartley Sweeten <hartleys@visionengravers.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
References: <201109231514.02174.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109231514.02174.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 03:14:01PM -0700, H Hartley Sweeten wrote:
> The function declaration in ext4.h is already marked extern.  The function
> definition should not have the tag.
> 
> This quiets the sparse noise:
> 
> warning: function 'ext4_flush_completed_IO' with external linkage has definition
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>

Thanks, applied.

						- Ted
