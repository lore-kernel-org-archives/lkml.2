Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab1HEDtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 23:49:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38797 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab1HEDtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 23:49:03 -0400
Date: Fri, 5 Aug 2011 04:48:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: NeilBrown <neilb@suse.de>
Cc: Josef Bacik <josef@redhat.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Subject: [PATCH] Restore 'fsync' functionality on block devices.
Message-ID: <20110805034859.GQ2203@ZenIV.linux.org.uk>
References: <20110805133456.5aa0c568@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805133456.5aa0c568@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 01:34:56PM +1000, NeilBrown wrote:
> 
> Commit 02c24a82187d5a628c68edfe71ae60dc135cd178:

see da5aa861bea09197e6ae4d7c46618616064891e4 in mainline
