Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1AVOrK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 09:47:10 -0500
Received: from void.printf.net ([89.145.121.20]:46974 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab1AVOrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 09:47:08 -0500
Date: Sat, 22 Jan 2011 14:47:04 +0000
From: Chris Ball <cjb@laptop.org>
To: Pierre Tardy <tardyp@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pierre Tardy <pierre.tardy@intel.com>
Subject: Re: [PATCH 3/3] mmc: remove anti clock gating quirk for wl1271
Message-ID: <20110122144704.GA13182@void.printf.net>
References: <cover.1294588491.git.tardyp@gmail.com> <cb471b35d320b96a9d143103fd9e9b76f8998470.1294588491.git.tardyp@gmail.com> <20110120041412.GA5274@void.printf.net> <AANLkTingXmestJGOpi0A0eywz63iKA0q=S1FFb8-q4OO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTingXmestJGOpi0A0eywz63iKA0q=S1FFb8-q4OO@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 08:17:51AM +0100, Pierre Tardy wrote:
> >
> > currently generate any warnings, so it would be good to avoid adding new
> > ones, though I understand why it might make sense in this case.
> Yes, this is supposed to be used by future user patches.
> 
> Do you suggest to add __attribute__ ((unused)), or we just completly
> remove those and will add them whenever we have user?

Yes, let's go with __attribute__ ((unused)) for now.  Thanks!

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
