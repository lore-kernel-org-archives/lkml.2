Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab0HJFp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 01:45:56 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:44235 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab0HJFpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 01:45:53 -0400
Date: Tue, 10 Aug 2010 08:45:30 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Grant Likely <grant.likely@secretlab.ca>
Cc: "Balbi Felipe (Nokia-MS/Helsinki)" <felipe.balbi@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "Tereshonkov Roman (Nokia-MS/Helsinki)" <roman.tereshonkov@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] spi: omap2_mcspi: make use of dev_vdbg()
Message-ID: <20100810054530.GD3853@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1275563341-31078-1-git-send-email-felipe.balbi@nokia.com>
 <20100809103618.GE11340@nokia.com>
 <AANLkTinA72_YkcyN=1q04CDG5uW8PiOz5+jg9nTN7PuE@mail.gmail.com>
 <20100810052146.GC3853@nokia.com>
 <AANLkTi=SyCye+dRZXKUF+yeXiXW2qZ5RETxvEYMq+myD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AANLkTi=SyCye+dRZXKUF+yeXiXW2qZ5RETxvEYMq+myD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 10, 2010 at 07:27:43AM +0200, ext Grant Likely wrote:
>I know, the sourceforge list is a bit of a pain.  I don't even know
>who the admin of that list is.  It was set up before I started the SPI
>maintainership.  I've been thinking about creating a new spi list on
>vger.kernel.org.

please do, that would make things a whole lot easier for plenty of 
developers. Specially the ones who are just coming up with simple 
patches once in a while :-)

-- 
balbi

DefectiveByDesign.org
