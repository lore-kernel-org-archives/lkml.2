Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab2JCQFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:05:21 -0400
Received: from 1wt.eu ([62.212.114.60]:35863 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932747Ab2JCQFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:05:20 -0400
Date: Wed, 3 Oct 2012 18:05:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alex Elder <aelder@sgi.com>, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [ 046/180] xfs: Fix possible memory corruption in xfs_readlink
Message-ID: <20121003160514.GF3889@1wt.eu>
References: <6a854f579a99b4fe2efaca1057e8ae22@local> <20121001225159.562823590@1wt.eu> <20121003150153.GA3222@herton-Z68MA-D2H-B3>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003150153.GA3222@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 12:01:54PM -0300, Herton Ronaldo Krzesinski wrote:
> This needs a followup fix, commit 9b025eb3a89e041bab6698e3858706be2385d692
> ("xfs: Fix missing xfs_iunlock() on error recovery path in xfs_readlink()").
> I think it should be also cherry-picked in this release.

Thanks Herton for the reporting this, fix queued.

Regards,
Willy

