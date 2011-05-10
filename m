Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab1EJMNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 08:13:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:58964 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab1EJMNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 08:13:22 -0400
Date: Tue, 10 May 2011 05:13:10 -0700
From: Greg KH <gregkh@suse.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: Re: [PATCH 005/206] Staging: hv: Rename the device type variable
Message-ID: <20110510121310.GA27396@suse.de>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-5-git-send-email-kys@microsoft.com>
 <4DC90F37.6010000@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC90F37.6010000@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 11:11:03AM +0100, Jonathan Cameron wrote:
> On 05/09/11 22:54, K. Y. Srinivasan wrote:
> > Rename the variable g_blk_device_type.
> Why?

Because "g_blk_device_type" is in Hungarian notation, which isn't needed
in the kernel.

thanks,

greg k-h
