Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2FHGvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 02:51:52 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44845 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2FHGvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 02:51:51 -0400
Date: Fri, 8 Jun 2012 09:51:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: serial2002: quiet NULL pointer sparse
 noise
Message-ID: <20120608065125.GL4400@mwanda>
References: <201206071714.25934.hartleys@visionengravers.com>
 <4FD19FBB.4040507@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD19FBB.4040507@mev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 07:46:19AM +0100, Ian Abbott wrote:
> On 08/06/12 01:14, H Hartley Sweeten wrote:
> >Quiet a number of sparse warnings in this file:
> >
> >warning: Using plain integer as NULL pointer
> 
> I wonder why sparse warns about that for a literal, unadorned 0?  I
> suppose NULL is more explicit, but a plain 0 means the same as NULL
> in a pointer context (unlike a zero from some random expression).
> 

http://lwn.net/Articles/93574/

regards,
dan carpenter

