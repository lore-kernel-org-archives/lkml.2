Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1DUSrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 14:47:41 -0400
Received: from imr4.ericy.com ([198.24.6.8]:45825 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab1DUSrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 14:47:39 -0400
Date: Thu, 21 Apr 2011 11:47:13 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] misc: Driver for Silicon Labs Si570 and compatibles
Message-ID: <20110421184713.GB29841@ericsson.com>
References: <1303248968-5069-1-git-send-email-guenter.roeck@ericsson.com>
 <201104211311.25988.arnd@arndb.de>
 <20110421155658.GA28245@ericsson.com>
 <201104211823.21384.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201104211823.21384.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 12:23:21PM -0400, Arnd Bergmann wrote:
> On Thursday 21 April 2011 17:56:58 Guenter Roeck wrote:
> > On Thu, Apr 21, 2011 at 07:11:25AM -0400, Arnd Bergmann wrote:
> > > On Wednesday 20 April 2011, Guenter Roeck wrote:
> > > 
> > > Isn't that what you'd normally call a 'struct clk' then?
> > > 
> > Yes, it would be nice to have that as part of the kernel and not architecture
> > specific.
> 
> I think the generalization of the ARM code is currently being worked
> on, so this should be there soon.
> 
Any pointers ?

Guenter
