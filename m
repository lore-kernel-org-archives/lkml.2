Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab1DESR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:17:26 -0400
Received: from kroah.org ([198.145.64.141]:44168 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385Ab1DESRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:17:20 -0400
Date: Tue, 5 Apr 2011 11:13:15 -0700
From: Greg KH <greg@kroah.com>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tony Olech <tony.olech@elandigitalsystems.com>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 25/34] usb/ftdi-elan: Drop __TIME__ usage
Message-ID: <20110405181315.GA22966@kroah.com>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
 <1302015561-21047-26-git-send-email-mmarek@suse.cz>
 <20110405175010.GB22862@one-eyed-alien.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110405175010.GB22862@one-eyed-alien.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 10:50:10AM -0700, Matthew Dharm wrote:
> On Tue, Apr 05, 2011 at 04:59:12PM +0200, Michal Marek wrote:
> > The kernel already prints its build timestamp during boot, no need to
> > repeat it in random drivers and produce different object files each
> > time.
> 
> What about drivers built as modules, which may be compiled at a different
> time than the rest of the kernel?

We don't care :)

thanks,

greg k-h
