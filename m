Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1AWW6m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 17:58:42 -0500
Received: from kroah.org ([198.145.64.141]:56889 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab1AWW6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 17:58:41 -0500
Date: Mon, 24 Jan 2011 07:59:35 +0900
From: Greg KH <greg@kroah.com>
To: Alan Ott <alan@signal11.us>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
        libusb-devel@lists.sourceforge.net
Subject: Re: [PATCH v2 1/1] hid: Add HID Report Descriptor to sysfs.
Message-ID: <20110123225935.GB12488@kroah.com>
References: <20110122135516.GA4893@kroah.com>
 <1295822107-6820-2-git-send-email-alan@signal11.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295822107-6820-2-git-send-email-alan@signal11.us>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 05:35:07PM -0500, Alan Ott wrote:
> Add a new binary sysfs entry called report_descriptor which contains
> the HID report descriptor.

Oops, I forgot to mention that any new sysfs file needs to be documented
in Documentation/ABI/

Can you please add that documentation to this patch so people know what
the file is, and what it is for?

thanks,

greg k-h
