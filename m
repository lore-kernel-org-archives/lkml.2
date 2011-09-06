Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab1IFXy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 19:54:28 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42642 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755411Ab1IFXyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 19:54:15 -0400
X-Sasl-enc: pIGCzJqxNwOEACODYHCRunt8em4kGtyxgDraybJqQO1Y 1315353254
Date: Tue, 6 Sep 2011 16:52:10 -0700
From: Greg KH <greg@kroah.com>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alan@linux.intel.com, wim@iguana.be,
        tomas.winkler@intel.com
Subject: Re: [PATCH 05/12 v2] staging: mei: adding watchdog ping
Message-ID: <20110906235210.GB26281@kroah.com>
References: <1314886137-18822-1-git-send-email-oren.jer.weil@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314886137-18822-1-git-send-email-oren.jer.weil@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 05:08:57PM +0300, Oren Weil wrote:
> adding watchdog ping to send ping/heartbeat to the the AMT watchdog client.
> in addition removing the heartbeat sending from the driver timers function.
> 
> Version 2 - Removed two tab indent

Oh great, now I notice this one.

Sorry, can you resend the whole series with this one included again,
I've purged your older series already.

thanks,

greg k-h
