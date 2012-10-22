Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab2JVUeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:34:10 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39553 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab2JVUeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:34:08 -0400
Date: Mon, 22 Oct 2012 13:34:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Adil Mujeeb <mujeeb.adil@gmail.com>
Cc: pavel@ucw.cz, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] Staging: winbond: Fixed coding style issues
Message-ID: <20121022203405.GA4395@kroah.com>
References: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 10:07:06PM +0530, Adil Mujeeb wrote:
> 
> winbond directory files have lots of coding style issues. The patch set tries to remove *most* (if not all) of the coding style issues. checkpatch.pl script is still complaining (like 80 characters limit) but major part of the serious coding style issues have been rectified. 

None of your patches can be applied due to the wrong patch level they
were generated at.  Please redo them, drop the two offending patches,
and resend the whole series.

thanks,

greg k-h
