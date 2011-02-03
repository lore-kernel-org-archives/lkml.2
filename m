Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab1BCBSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 20:18:47 -0500
Received: from straum.hexapodia.org ([207.7.131.186]:59362 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab1BCBSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 20:18:46 -0500
Date: Wed, 2 Feb 2011 17:18:45 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS stat/statvfs problems with 2.6.38-rc2-00175-g6fb1b30
Message-ID: <20110203011845.GL11874@hexapodia.org>
References: <20110202023644.GA25214@hexapodia.org> <20110202221858.GS11040@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202221858.GS11040@dastard>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 09:18:58AM +1100, Dave Chinner wrote:
> On Tue, Feb 01, 2011 at 06:36:44PM -0800, Andy Isaacson wrote:
> > Since updating past 2.6.37, I'm seeing du(1) sometimes report files
> > taking up 8GB even though ls(1) reports the correct size (hundreds of
> 
> It'll be the excessive specualtive preallocation bug introduced in
> .38-rc1  which is fixed in .38-rc3.

Indeed, I've been running 2.6.38-rc3-00019-gafe8a88 for 18 hours now
with the same load and not seen any issues.

Thanks,
-andy
