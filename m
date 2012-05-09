Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250Ab2EIQp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:45:59 -0400
Received: from twin.jikos.cz ([89.185.236.188]:38517 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758285Ab2EIQp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:45:57 -0400
Date: Wed, 9 May 2012 18:45:49 +0200
From: David Sterba <dave@jikos.cz>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use ALIGN macro instead of open-coded expression
Message-ID: <20120509164549.GM19331@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
	chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1336464984-30746-1-git-send-email-yuanhan.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336464984-30746-1-git-send-email-yuanhan.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 04:16:24PM +0800, Yuanhan Liu wrote:
> According to section 'Find open-coded helpers or macros' at
> https://btrfs.wiki.kernel.org/index.php/Cleanup_ideas, here
> in the patch we use ALIGN macro to do the alignment.

Well, I wrote this section and some time later also the patches,
http://www.spinics.net/lists/linux-btrfs/msg12747.html

but did not update the section with the status reflecting this, sorry
that you duplicated work.


david
