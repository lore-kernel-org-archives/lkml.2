Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab2BWAC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 19:02:56 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:34988 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab2BWACy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 19:02:54 -0500
Date: Thu, 23 Feb 2012 09:02:40 +0900
From: Norbert Preining <preining@logic.at>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Lin Ming <ming.m.lin@intel.com>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        "Rafael J . Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v2 0/3] ahci: fix boot/resume COMRESET failures
Message-ID: <20120223000240.GA1931@gamma.logic.tuwien.ac.at>
References: <1329849524-23758-1-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329849524-23758-1-git-send-email-computersforpeace@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 21 Feb 2012, Brian Norris wrote:
> This series addresses regression problems with
> 
>     commit 7faa33da9b7add01db9f1ad92c6a5d9145e940a7
>     ahci: start engine only during soft/hard resets
> 
> Because the fix provided by the above commit caused COMRESET failures and
> 10 second boot-time/resume-time hangs for certain DVD drives, we need to
> make the fix conditional to certain devices/platforms. Add a flag for this.

I confirm that these patches without the previous fix also 
fixes the regression I have seen. Thanks.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SHIRMERS (pl.n.)
Tall young men who stand around smiling at weddings as if to suggest
that they know they bride reather well.
			--- Douglas Adams, The Meaning of Liff
