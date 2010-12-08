Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab0LHESl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 23:18:41 -0500
Received: from kroah.org ([198.145.64.141]:51397 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab0LHESk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 23:18:40 -0500
Date: Tue, 7 Dec 2010 20:15:28 -0800
From: Greg KH <greg@kroah.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH 1/3] x86-32: Separate 1:1 pagetables from swapper_pg_dir
Message-ID: <20101208041528.GA2211@kroah.com>
References: <20101111141358.GA4641@kroah.com>
 <1289488576-18117-2-git-send-email-joerg.roedel@amd.com>
 <20101207210512.GA14849@kroah.com>
 <4CFEF637.4020203@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CFEF637.4020203@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 07:06:31PM -0800, Jeremy Fitzhardinge wrote:
> On 12/07/2010 01:05 PM, Greg KH wrote:
> > On Thu, Nov 11, 2010 at 04:16:14PM +0100, Joerg Roedel wrote:
> >> commit fd89a137924e0710078c3ae855e7cec1c43cb845 upstream
> > applied, thanks.
> 
> This will need as well 5b5c1af104ab5adec1be9dcb4c787492d83d8d83 to
> prevent Xen regressions.

So should I add that to a specific release?  The next .36 stable or
something else?

confused,

greg k-h
