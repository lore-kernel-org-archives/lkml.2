Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab1HJPTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:19:43 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43180 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753273Ab1HJPTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:19:42 -0400
X-Sasl-enc: txnP4nt0fsBIo131R7EAJA2KBQNUqsDLRInoMne3qCrZ 1312989581
Date: Wed, 10 Aug 2011 08:19:05 -0700
From: Greg KH <greg@kroah.com>
To: Corey Richardson <kb1pkl@aim.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdev_t.h old major/minor numbers
Message-ID: <20110810151905.GA28197@kroah.com>
References: <1312964160-sup-7942@hpsetup>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312964160-sup-7942@hpsetup>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 04:21:15AM -0400, Corey Richardson wrote:
> 
> While reading through some of the kernel stuff I noticed that the macros
> at the end of include/linux/kdev_t.h were out-of-sync with the macros at
> the top. I'm not certain when/if they would ever be defined and not the
> other ones (I'm very new to the kernel), but I would assume that they
> shouldn't be using the old 255-number system.
> 
> Was this just an oversight or is there something else going on?

No, it is done this way on purpose, please read the comment right before
the code you just changed.

greg k-h
