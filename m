Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1KGPxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:53:30 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:49061 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab1KGPx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:53:28 -0500
Date: Mon, 7 Nov 2011 10:53:26 -0500
To: Richard Weinberger <richard@nod.at>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        adilger.kernel@dilger.ca
Subject: Re: [PATCH 1/3] ext4: Remove kernel_lock annotations
Message-ID: <20111107155326.GC24234@thunk.org>
Mail-Followup-To: tytso@mit.edu, Richard Weinberger <richard@nod.at>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	adilger.kernel@dilger.ca
References: <1320654148-4394-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320654148-4394-1-git-send-email-richard@nod.at>
1;2305;0cFrom: Ted Ts'o <tytso@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "Ted Ts'o" <tytso@thunk.org>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 09:22:28AM +0100, Richard Weinberger wrote:
> The BKL is gone, these annotations are useless.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Thanks, applied to the ext4 tree.

				- Ted
