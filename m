Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934243Ab2FHJtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 05:49:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42987 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665Ab2FHJtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 05:49:06 -0400
Date: Fri, 8 Jun 2012 12:48:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH] staging: comedi: serial2002: quiet NULL pointer sparse
 noise
Message-ID: <20120608094842.GM4400@mwanda>
References: <201206071714.25934.hartleys@visionengravers.com>
 <4FD19FBB.4040507@mev.co.uk>
 <20120608065125.GL4400@mwanda>
 <4FD1C0D2.8060704@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD1C0D2.8060704@mev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 10:07:30AM +0100, Ian Abbott wrote:
> I wonder if it also issues that warning for a struct initializer such as
> {0} where the first member of the struct is a pointer, or would it
> expect you to use {NULL} which is more confusing when the struct
> contains a mixture of pointer and non-pointer members?
> 

It does warn about that.  The fix is to just say:

	struct foo bar = {};

regards,
dan carpenter
