Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030366Ab2CBPrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:47:52 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62666 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758787Ab2CBPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:47:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.125.195 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Fri, 2 Mar 2012 07:37:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/34] 2.6.32.58-longterm review
Message-ID: <20120302153728.GA27141@kroah.com>
References: <20120301214654.GA13231@kroah.com>
 <20120302071914.GC13959@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302071914.GC13959@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 08:19:14AM +0100, Willy Tarreau wrote:
> Hi Greg,
> 
> On Thu, Mar 01, 2012 at 01:46:54PM -0800, Greg KH wrote:
> > NOTE:
> > 	I have NOT tested this rc release.  I now no longer own any
> > 	machines that can run the 2.6.32 kernel.  Because of this, this
> > 	will be the last 2.6.32-longterm kernel that I will release.  I
> > 	will be passing on the .32 kernel to someone else after this
> > 	release.  Please, if you care about the .32 kernel, test this
> > 	release, I have _only_ build tested it, and have no idea if I
> > 	got something wrong or not.
> 
> OK, tested here on an atom-based netbook (x86-32+i915 graphics).
> WiFi (incl firmware loading), bluetooth (over USB), NFS, suspend/resume,
> ACPI were tested with success. So I think that once again you did the job
> right till your last release :-)

Great, thanks for testing and letting me know.

greg k-h
