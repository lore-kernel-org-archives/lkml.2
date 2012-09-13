Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab2IMQ6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 12:58:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42703 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab2IMQ6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 12:58:48 -0400
Date: Thu, 13 Sep 2012 09:58:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: "Patil, Rachna" <rachna@ti.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-iio@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH v3 4/5] IIO : ADC: tiadc: Add support of TI's ADC driver
Message-ID: <20120913165833.GC3519@core.coreip.homeip.net>
References: <1347532819-505-1-git-send-email-rachna@ti.com>
 <1347532819-505-5-git-send-email-rachna@ti.com>
 <5051CDEA.5080200@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5051CDEA.5080200@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 01:13:30PM +0100, Jonathan Cameron wrote:
> On 13/09/12 11:40, Patil, Rachna wrote:
> >This patch adds support for TI's ADC driver.
> >This is a multifunctional device.
> >Analog input lines are provided on which
> >voltage measurements can be carried out.
> >You can have upto 8 input lines.
> >
> >Signed-off-by: Patil, Rachna <rachna@ti.com>
> 
> There's a little fuzz in applying this due to other drivers that have
> gone in recently.
> 
> Actually this is going to be 'interesting' to merge. Dmitry, Samuel
> thoughts on who takes this one and how?  Maybe this is a case for a
> 'special' branch pulled into more than one tree?

I'd be OK with it going through MFD tree.

-- 
Dmitry
