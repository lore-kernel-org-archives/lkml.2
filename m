Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab1DERbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:31:37 -0400
Received: from kroah.org ([198.145.64.141]:53805 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab1DERbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:31:35 -0400
Date: Tue, 5 Apr 2011 10:30:28 -0700
From: Greg KH <greg@kroah.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>, mikew@google.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: /sys/firmware/dmi name change?
Message-ID: <20110405173028.GC20622@kroah.com>
References: <4D9B4E3A.4090601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9B4E3A.4090601@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 01:15:38PM -0400, Prarit Bhargava wrote:
> commit 948af1f0bbc8526448e8cbe3f8d3bf211bdf5181 (and follow on commits)
> introduced a new firmware directory called /sys/firmware/dmi which
> provides broken out SMBIOS entries for userspace.
> 
> In a previous discussion I've mentioned that it would be a good idea for
> us to move away from using 'dmi' towards using 'smbios' and centralizing
> the SMBIOS code that is scattered throughout the kernel.  One of my
> changes was to export the SMBIOS information in a similar way that Mike
> did in drivers/firmware/dmi-sysfs.c.
> 
> Since this API is new for 2.6.39, can we change the name of the
> directory to /sys/firmware/smbios?  Otherwise in 2.6.40, when further
> changes are introduced to use SMBIOS in the kernel we will have to
> change something that has been stable for one release.
> 
> Mike?  Greg?  Alan?  What do you think?  IIUC, the interface isn't yet
> "stable" so it should be changed now, correct?

Fine with me if Mike's ok with it as well.  If so, someone send me a
patch quick!

thanks,

greg k-h
