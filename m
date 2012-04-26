Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab2DZVQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:16:08 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:55334 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab2DZVQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:16:05 -0400
Date: Thu, 26 Apr 2012 14:16:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andre Przywara <andre.przywara@amd.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [ 03/42] hwmon: fam15h_power: fix bogus values with current
 BIOSes
Message-ID: <20120426211601.GB372@kroah.com>
References: <20120424223311.GA8456@kroah.com>
 <20120424223253.715186078@linuxfoundation.org>
 <20120425194615.GH3932@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425194615.GH3932@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 08:46:15PM +0100, Ben Hutchings wrote:
> On Tue, Apr 24, 2012 at 03:32:56PM -0700, Greg KH wrote:
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> [...]
> 
> This should also be droped from the 3.0-stable queue for now.

Now dropped, thanks for finding this.

greg k-h
