Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab2KTK5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 05:57:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab2KTK5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 05:57:02 -0500
Date: Tue, 20 Nov 2012 11:57:00 +0100
From: Michal Marek <mmarek@suse.cz>
To: Andreas =?iso-8859-1?Q?Bie=DFmann?= <andreas@biessmann.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/pnmtologo: fix for plain PBM
Message-ID: <20121120105700.GC31243@sepie.suse.cz>
References: <1350551329-3521-1-git-send-email-andreas@biessmann.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1350551329-3521-1-git-send-email-andreas@biessmann.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 11:08:49AM +0200, Andreas Bieﬂmann wrote:
> PBM generated with current tools do not have a whitespace between the digits.
> Therefore the pnmtologo tool fails to gernerate the required C-Array for these
> images.  This patch fixes that behaviour and can handle both 'old style' and
> 'new style' PBM files.
> 
> Signed-off-by: Andreas Bieﬂmann <andreas@biessmann.de>

Applied to kbuild.git#kbuild, thanks.

Michal
