Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab2DEIMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:12:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:27200 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab2DEIMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:12:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="127369620"
Date: Thu, 5 Apr 2012 11:13:03 +0300
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: ranjith kumar <ranjithproxy@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: regarding transfer of files through bluetooth, WIFI and WIFI
 direct
Message-ID: <20120405081255.GC804@aemeltch-MOBL1>
References: <CAG9fbzaEzPMn6uBmobR2C+Hd6rjxRMNQpQBLhr7S1wnEQRTZNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG9fbzaEzPMn6uBmobR2C+Hd6rjxRMNQpQBLhr7S1wnEQRTZNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 05, 2012 at 01:35:01PM +0530, ranjith kumar wrote:
> Hi,
> I want to transfer image files  through bluetooth between two computers.
> Which profile I have to use?
> 
> I dont know much about "Basic Imaging Profile".
> But the thing is that I cant use Basic image profile.
> 
> So what profile I have to use for transfer of files? Can I use OBEX
> profile for that?

Yes you can. This shall be supported in your distro.

> Also want transfer video files through WIFI and WIFI direct.

Check this out:

http://wireless.kernel.org/en/developers/p2p/howto

Best regards 
Andrei Emeltchenko 

