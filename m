Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946326Ab2EKWKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:10:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47862 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933305Ab2EKWK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:10:28 -0400
Date: Fri, 11 May 2012 15:10:24 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Du, ChangbinX" <changbinx.du@intel.com>
Cc: "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/3] testusb: fix a makefile bug in tools/usb
Message-ID: <20120511221024.GE13675@kroah.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A060D00@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A060D00@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 11:00:01AM +0000, Du, ChangbinX wrote:
> For gcc, link options must behind of compiling options, else it could lead to "undefined reference ..." error since gcc cannot find specific library.

How is this working today?  What version of gcc causes this change to be
needed?  What about clang, does this also work there?

And please, wrap your changelog comments at column 72.

Care to resend after providing this information?

thanks,

greg k-h
