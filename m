Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab2CMNrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:47:41 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:53202 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab2CMNrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:47:39 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lq3M7qFLaZ
X-RZG-CLASS-ID: mo00
Date: Tue, 13 Mar 2012 14:47:30 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [34-longterm 020/196] staging: hv: use sync_bitops when
 interacting with the hypervisor
Message-ID: <20120313134730.GB15096@aepfle.de>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331597724-31358-21-git-send-email-paul.gortmaker@windriver.com>
 <20120313070002.GA19629@aepfle.de>
 <4F5F4C86.5050501@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F5F4C86.5050501@windriver.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, Paul Gortmaker wrote:

> On 12-03-13 03:00 AM, Olaf Hering wrote:
> > On Mon, Mar 12, Paul Gortmaker wrote:
> > 
> >> From: Olaf Hering <olaf@aepfle.de>
> >>
> >>                    -------------------
> >>     This is a commit scheduled for the next v2.6.34 longterm release.
> >>     If you see a problem with using this for longterm, please comment.
> >>                    -------------------
> >>
> >> commit 22356585712d1ff08fbfed152edd8b386873b238 upstream.
> > 
> > Unless there is a happy user of the hv drivers in this old kernel, it
> > makes no sense to backport just this one patch.
> 
> There is no real way any of can tell just exactly who is using what
> feature in what release.

Sure.
As it stands, the hv drivers in this version are not very stable, more
backports are needed. So whoever is using .34 as a base will most likely
have many more changes in his patchset.

If you want to apply this change, go ahead. I just wanted to point out
the state of the drivers.

Olaf
