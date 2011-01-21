Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1AUAIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 19:08:46 -0500
Received: from kroah.org ([198.145.64.141]:56110 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab1AUAIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 19:08:45 -0500
Date: Thu, 20 Jan 2011 16:05:18 -0800
From: Greg KH <greg@kroah.com>
To: Ralph Loader <suckfish@ihug.co.nz>
Cc: Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix some incorrect use of positive error codes.
Message-ID: <20110121000518.GA14997@kroah.com>
References: <20101226185718.aa60e0cd.suckfish@ihug.co.nz>
 <alpine.LNX.2.00.1012271227260.16569@pobox.suse.cz>
 <20101229120116.9eeb9261.suckfish@ihug.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101229120116.9eeb9261.suckfish@ihug.co.nz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 12:01:16PM +1300, Ralph Loader wrote:
> Jiri Kosina <jkosina@suse.cz> wrote:
> > Could you please split the staging bits and submit them separately to 
> > Greg?
> 
> As Jiri requested, the staging fixes as a separate commit.  I'll
> repost the non-staging changes as a separate commit also.

This doesn't seem to apply at the moment, care to redo it against the
latest linux-next tree?

thanks,

greg k-h
