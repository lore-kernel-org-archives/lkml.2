Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab0E1Qrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 12:47:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:42495 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515Ab0E1Qrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 12:47:32 -0400
Date: Fri, 28 May 2010 09:47:25 -0700
From: Greg KH <gregkh@suse.de>
To: Cliff Wickman <cpw@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH V3] x86, UV: BAU performance and error recovery
Message-ID: <20100528164725.GA29208@suse.de>
References: <E1OHzgl-0000Pj-6o@eag09.americas.sgi.com>
 <4BFFEFA1.1020307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFFEFA1.1020307@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 09:30:25AM -0700, H. Peter Anvin wrote:
> On 05/28/2010 06:33 AM, Cliff Wickman wrote:
> > - adds modification of tuning variables through /proc/sgi_uv
> 
> Adding new directories in /proc for a proprietary architecture is
> frowned upon, to put it mildly.  At the very least try to find a place
> in sysfs for it.
> 
> [Cc: gregkh in order to find a place in sysfs]

Hm, what type of files are you needing here?  Do they corrispond with
any specific hardware devices?  If so, just put them on the hardware
devices in sysfs.

thanks,

greg k-h
