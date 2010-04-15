Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab0DOSCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:02:51 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41066 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755343Ab0DOSCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:02:50 -0400
Date: Thu, 15 Apr 2010 20:02:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: S2RAM broken on HP 8530p
Message-ID: <20100415180235.GB1443@ucw.cz>
References: <alpine.DEB.2.00.1003312050370.1876@parag-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003312050370.1876@parag-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-03-31 21:05:09, Parag Warudkar wrote:
> 
> Running Ubuntu Lucid 64-bit I noticed suspending fails with current git. 
> Unsure since when it started - perhaps a while ago since the stock distro 
> kernel 2.6.32-18 also fails to suspend - albeit little differently - 
> git will fail before shutting off the display, distro one succeeds in 
> shutting off the display and then hangs.
> 
> Any ideas how to go about debugging this? 

retry with minimal config? /sys/power/pm_test?

bisect?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
