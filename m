Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2AIPRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:17:10 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:55842 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab2AIPRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:17:08 -0500
Date: Mon, 9 Jan 2012 10:17:07 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Shantanu Goel <sgoel01@yahoo.com>
Cc: Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: Fix up range_end offset in range cyclic writeback
Message-ID: <20120109151707.GB22175@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Shantanu Goel <sgoel01@yahoo.com>,
	Kernel <linux-kernel@vger.kernel.org>
References: <1325993012.29526.YahooMailNeo@web38004.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1325993012.29526.YahooMailNeo@web38004.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 07, 2012 at 07:23:32PM -0800, Shantanu Goel wrote:
> 
> 
> The patch below fixes the range_end calculation which should be a
> byte offset and not a page index.  Also, the patch updates the `end'
> index as well when looping again in range cyclic mode.

Hi Shantanu,

This patch looks good; thanks for spotting this!  Can I ask how you
spotted this and whether it was by code inspection because the
incorrect code was causing some serious problem?

Basically, it's late in the merge window, and I'd rather not include
any new patches unless they are fixing a serious problem at this
point.  Otherwise, I'll make sure it gets merged for the next merge
window.

Thanks,

						- Ted
