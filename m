Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761178Ab2EIUmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:42:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57283 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758639Ab2EIUmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:42:53 -0400
Date: Wed, 9 May 2012 13:42:50 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: remove __user annotation inside of
 struct's
Message-ID: <20120509204250.GA22210@kroah.com>
References: <201205081641.00358.hartleys@visionengravers.com>
 <ADE657CA350FB648AAC2C43247A983F0020698A1774D@AUSP01VMBX24.collaborationhost.net>
 <4FAA44D7.1040209@mev.co.uk>
 <20120509142436.GC11695@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698A17862@AUSP01VMBX24.collaborationhost.net>
 <20120509155653.GA23058@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698A17888@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698A17888@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 11:41:26AM -0500, H Hartley Sweeten wrote:
> On Wednesday, May 09, 2012 8:57 AM, gregkh@linuxfoundation.org wrote:
> > On Wed, May 09, 2012 at 10:52:34AM -0500, H Hartley Sweeten wrote:
> >> Based on the discussion I assume this patch is ok then. Do you
> >> want me to repost it?
> >
> > Sure, I'll review it with the other patches you have sent later today.
> 
> Greg,
> 
> I have re-posted the patch with an updated commit message. I
> also posted a v2 patch for the sysfs change (cut-paste issue).
> 
> I'll hold off on any other changes until you have had a chance to
> review all the others.

I've applied all of your patches, with the exception of the v2 version
of this patch, see my comments on it for why.

thanks,

greg k-h
