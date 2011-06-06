Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1FFXju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 19:39:50 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47495 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753798Ab1FFXjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:39:49 -0400
X-Sasl-enc: kxPrw0v66shukI2XEho701iwr0i/ozOG1Sg8pZHVhTDy 1307403588
Date: Mon, 6 Jun 2011 16:35:23 -0700
From: Greg KH <greg@kroah.com>
To: Russ Gorby <russ.gorby@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com
Subject: Re: [PATCHv2 0/5] N_GSM patchset : 06/03/2011: v2
Message-ID: <20110606233523.GA13043@kroah.com>
References: <1307144642-5915-1-git-send-email-russ.gorby@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307144642-5915-1-git-send-email-russ.gorby@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 04:43:55PM -0700, Russ Gorby wrote:
> Hello N_GSM Maintainers,
> 
> I'm sending this patchset
> 
> [PATCHv2 0/5] N_GSM patchset : 06/03/2011: v2
> 
> This patchset is the same as version 1 except it contains 2
> additional patches that are needed to make the network interface
> functionality usable.
> These are the pertinent changes that we have done to the driver.
> Thank you for yor comments.

The next time you resend these, please send them with the bugfixes
first, so I can send them to Linus before 3.0 is out, and the others
will get queued up for 3.1.

thanks,

greg k-h
