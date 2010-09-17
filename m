Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0IQRHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 13:07:38 -0400
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:55942 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab0IQRHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 13:07:37 -0400
X-Greylist: delayed 1211 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Sep 2010 13:07:37 EDT
Date: Fri, 17 Sep 2010 12:47:23 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Sudden "hangs"....
Message-ID: <20100917164723.GA13770@animx.eu.org>
Mail-Followup-To: Rogier Wolff <R.E.Wolff@BitWizard.nl>,
	linux-kernel@vger.kernel.org
References: <20100916143304.GA14874@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916143304.GA14874@bitwizard.nl>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rogier Wolff wrote:
> It seems my home workstation hangs on a "mkdir" once every morning for
> about half a minute. It'll freeze whatever I'm doing and continue
> happily 30 seconds later, but I can't figure out what's going on
> because it's frozen...

One of my volumes was doing this.  As someone mentioned earlier, check your
kernel log to see if you have a disk error.  On mine, I had no errors.  The
activity led for that volume would be on solid until the mkdir completed. 
My fix was to create a new directory and move everything over and remove the
old directory.  Obviously this won't work if you're having problems with
more than 1 directory or the offending directory is the root of the volume.

Just for information, this volume I have is on a single disk created on the
whole disk (no lvm nor partition).

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
