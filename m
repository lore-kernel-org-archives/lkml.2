Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab2F0SwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:52:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64049 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2F0SwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:52:05 -0400
Date: Wed, 27 Jun 2012 11:51:59 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "sclark46@earthlink.net" <sclark46@earthlink.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/36] staging: comedi: cb_pcidas: cleanup the driver
Message-ID: <20120627185159.GA23014@kroah.com>
References: <201206261745.00636.hartleys@visionengravers.com>
 <4FEB3553.8050609@earthlink.net>
 <ADE657CA350FB648AAC2C43247A983F0020698F2E703@AUSP01VMBX24.collaborationhost.net>
 <4FEB3CAA.3060300@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEB3CAA.3060300@mev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 06:02:34PM +0100, Ian Abbott wrote:
> On 2012-06-27 17:45, H Hartley Sweeten wrote:
> >On Wednesday, June 27, 2012 9:31 AM, Stephen Clark wrote:
> >>I there some reason you can't post these as response to this message,
> >>like GKH does, so if readers aren't
> >>interested they can mark the thread read without stepping thru each patch.
> >
> >The only reason is, I'm not sure how to do that... ;-)
> >
> >Greg, any pointers on how?
> 
> The easiest way is to use the --compose option of git send-email,
> which lets you edit an introductory email to the patch series you
> are posting and uses that email's ID as the --in-reply-to for all
> the following patch emails (assuming you don't have --chain-reply-to
> set).

Yes, that's the easiest way to do this, and is what I recommend.

greg k-h
