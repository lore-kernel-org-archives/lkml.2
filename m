Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946295Ab2EKWI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:08:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946251Ab2EKWIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:08:25 -0400
Date: Fri, 11 May 2012 15:08:19 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Du, ChangbinX" <changbinx.du@intel.com>
Cc: "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 3/3] testusb: improve testing output pattern
Message-ID: <20120511220819.GC13675@kroah.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A060D13@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A060D13@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 11:02:16AM +0000, Du, ChangbinX wrote:
> 1. more help message to make it easier to use.
> 2. print VID/PID for each device found.
> 3. each case testing result is displayed by columns "DEVICE","TEST-NUM"," RESULT","DURATION(s)","ERROR".
> output example:

You seem to be mixing a number of different changes all in one patch.
Care to break this up into smaller patches, each one only doing one
thing, so we can properly review and apply them?

thanks,

greg k-h
