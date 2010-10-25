Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0JYOvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:51:07 -0400
Received: from thunk.org ([69.25.196.29]:46709 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab0JYOvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:51:06 -0400
Date: Mon, 25 Oct 2010 10:51:02 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: Check return value of sb_getblk() and friends
Message-ID: <20101025145102.GE16981@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Namhyung Kim <namhyung@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1287476529-5314-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287476529-5314-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 05:22:09PM +0900, Namhyung Kim wrote:
> Fail block allocation if sb_getblk() returns NULL. In that case,
> sb_find_get_block() also likely to fail so that it should skip
> calling ext4_forget().
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Thanks, I've added this patch to the ext4 patch queue.

       	    	       	     	    - Ted
