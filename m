Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab1HHEXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 00:23:17 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58337 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241Ab1HHEXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 00:23:13 -0400
X-Sasl-enc: w9F1SCfgc0By9r9XF2lUnf0A+r7YDlX7BBVOzEdI0AXp 1312777391
Date: Sun, 7 Aug 2011 21:22:31 -0700
From: Greg KH <greg@kroah.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.0: broken ums_eneub6250
Message-ID: <20110808042231.GA6248@kroah.com>
References: <hjXX6-Ee-55@gated-at.bofh.it>
 <hk6nE-6kT-5@gated-at.bofh.it>
 <hk7Wq-mZ-1@gated-at.bofh.it>
 <j1mm4l$55a$1@ID-44327.news.uni-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <j1mm4l$55a$1@ID-44327.news.uni-berlin.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 07, 2011 at 08:39:20PM +0200, Andreas Hartmann wrote:
> Hi,
> 
> obviously, nobody seems to be interested to work on this bug. Until it's
> fixed: There is a workaround to get the device working again with 2.6.39
> and 3.0 - just remove the unusable ums-eneub6250.ko and replace it with
> the complete old and fine keucr-module - staging but working :-)
> 
> https://bugzilla.novell.com/show_bug.cgi?id=709243#c1

How about working on a patch for the in-kernel version of the code to
get it to work properly so we can resolve this?  Given that very few
people actually have this hardware, it's hard for us to work on the
driver.

If you could run 'git bisect' to try to find the problem, that would be
appreciated.

thanks,

greg k-h
