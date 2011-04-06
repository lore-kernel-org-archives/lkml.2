Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1DGAKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 20:10:21 -0400
Received: from SMTP03.SRV.CS.CMU.EDU ([128.2.217.198]:38120 "EHLO
	smtp03.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab1DGAKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 20:10:20 -0400
X-Greylist: delayed 2825 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Apr 2011 20:10:20 EDT
Date: Wed, 6 Apr 2011 19:23:10 -0400
From: Eric Cooper <ecc@cmu.edu>
To: linux-arm-kernel@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: Differentiate SheevaPlugs and DockStars on the
 basis of the memory size.
Message-ID: <20110406232310.GD18400@localhost>
Mail-Followup-To: linux-arm-kernel@lists.infradead.org,
	lkml <linux-kernel@vger.kernel.org>
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de>
 <1302122121-3652-2-git-send-email-holler@ahsoftware.de>
 <alpine.LFD.2.00.1104061739100.28032@xanadu.home>
 <4D9CED15.2010806@ahsoftware.de>
 <alpine.LFD.2.00.1104061850410.28032@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1104061850410.28032@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 07:01:07PM -0400, Nicolas Pitre wrote:
> Is the code for DockStar in mainline actually useful?

Yes, because it sets up the correct LEDs.

-- 
Eric Cooper             e c c @ c m u . e d u
