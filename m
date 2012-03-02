Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964927Ab2CBHT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:19:27 -0500
Received: from 1wt.eu ([62.212.114.60]:62756 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199Ab2CBHT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:19:26 -0500
Date: Fri, 2 Mar 2012 08:19:14 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/34] 2.6.32.58-longterm review
Message-ID: <20120302071914.GC13959@1wt.eu>
References: <20120301214654.GA13231@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120301214654.GA13231@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Mar 01, 2012 at 01:46:54PM -0800, Greg KH wrote:
> NOTE:
> 	I have NOT tested this rc release.  I now no longer own any
> 	machines that can run the 2.6.32 kernel.  Because of this, this
> 	will be the last 2.6.32-longterm kernel that I will release.  I
> 	will be passing on the .32 kernel to someone else after this
> 	release.  Please, if you care about the .32 kernel, test this
> 	release, I have _only_ build tested it, and have no idea if I
> 	got something wrong or not.

OK, tested here on an atom-based netbook (x86-32+i915 graphics).
WiFi (incl firmware loading), bluetooth (over USB), NFS, suspend/resume,
ACPI were tested with success. So I think that once again you did the job
right till your last release :-)

Cheers,
Willy

