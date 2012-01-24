Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab2AXQyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:54:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706Ab2AXQyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:54:50 -0500
Date: Tue, 24 Jan 2012 08:52:04 -0800
From: Greg KH <gregkh@suse.de>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [000/129] 3.2.2-stable review
Message-ID: <20120124165204.GB26552@suse.de>
References: <20120124024041.GA18422@kroah.com>
 <4F1E5B88.50801@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1E5B88.50801@compulab.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 09:19:36AM +0200, Igor Grinberg wrote:
> Hi Greg,
> 
> On 01/24/12 04:40, Greg KH wrote:
> > #include <stable/formletter.h>
> > #define RELEASE		3.2.2-rc1
> > #define NUM_PATCHES	129
> > #define RESPONSE_DATE	"Wed, Jan 25, 2012 20:00:00 +0000"
> > #define LOCATION	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.2.2-rc1.gz
> > 
> > diffstat below, no one really reads these things anyway...
> 
> This is not exactly true...
> I'm (and I think I'm not the only one) going through the diffstat
> to see if there are any files of my interest involved,
> because it is not always straight forward to understand what
> the patch subject means and also there are too many of them to read all...
> So, for me, the compromise between being updated on important issues
> and spend not too much time reading patches subjects/message is
> read the diffstat and if I find anything that is of my interest,
> then go to the patches...
> May be not the best, but works for me...

Sorry, I didn't mean to imply that no one reads the diffstat, I ment the
other generic wording that I've had in the announcement emails for the
past 6 years.

Glad it's still useful for you.

greg k-h
