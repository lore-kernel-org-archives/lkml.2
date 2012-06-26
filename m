Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab2FZAYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:24:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59605 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083Ab2FZAYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:24:09 -0400
Date: Mon, 25 Jun 2012 17:24:05 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
Subject: Re: [PATCH 19/33] staging: comedi: cb_das16_cs: cleanup dio
 subdevice initialization
Message-ID: <20120626002405.GA4497@kroah.com>
References: <201206251700.20240.hartleys@visionengravers.com>
 <ADE657CA350FB648AAC2C43247A983F0020698E778DE@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698E778DE@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 07:09:39PM -0500, H Hartley Sweeten wrote:
> On Monday, June 25, 2012 5:00 PM, H Hartley Sweeten wrote:
> > The digital i/o subdevice is always initialized due to the 'if (1)'.
> > Simplify the attach by removing the test.
> >
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> > Cc: Ian Abbott <abbotti@mev.co.uk>
> > Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Grr... Did it again.
> 
> Sorry Greg. That should be a Cc not a Signed-off-by. Do you want
> me to repost these?

No problem, I'll edit it out.

