Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab1ATQlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:41:36 -0500
Received: from kroah.org ([198.145.64.141]:40859 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab1ATQle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:41:34 -0500
Date: Thu, 20 Jan 2011 08:38:11 -0800
From: Greg KH <greg@kroah.com>
To: Maya Erez <merez@codeaurora.org>
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH v4] usb: Add streams support to the gadget
 framework.
Message-ID: <20110120163811.GB30680@kroah.com>
References: <1295523914-20056-1-git-send-email-merez@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295523914-20056-1-git-send-email-merez@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 01:45:13PM +0200, Maya Erez wrote:
> Add the capability to search for an EP with a required
> number of streams.

Why?  What in-kernel code needs this?

> Keep the stream ID for each usb_request.

Again, why?

thanks,

greg k-h
