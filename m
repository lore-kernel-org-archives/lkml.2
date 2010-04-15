Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab0DPFX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 01:23:58 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:42339 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752351Ab0DPFX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 01:23:57 -0400
Date: Thu, 15 Apr 2010 21:12:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, khali@linux-fr.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] liss331d1: accelerometer driver
Message-ID: <20100415191227.GA1559@ucw.cz>
References: <20100414124913.23181.75903.stgit@localhost.localdomain> <20100414125155.23181.56610.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414125155.23181.56610.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-04-14 13:52:00, Alan Cox wrote:
> From: Kalhan Trisal <kalhan.trisal@intel.com>
> 
> The acceleremeter driver reads the x,y,z coordinate registers and provides
> the information to user through the input layer
> 
> Conversion to input device, clean up and porting of retry fixes needed
> for AAVA done by Alan Cox.

Out of interest, what is AAVA?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
