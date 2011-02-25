Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871Ab1BYUDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:03:42 -0500
Received: from kroah.org ([198.145.64.141]:60149 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932648Ab1BYUDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:03:41 -0500
Date: Fri, 25 Feb 2011 12:03:13 -0800
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Olof Johansson <olofj@chromium.org>, Andi Kleen <andi@firstfloor.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Robert Lippert <rlippert@google.com>, Jon Mayer <jonmayer@google.com>,
        Tony Luck <tony.luck@intel.com>, Duncan Laurie <dlaurie@google.com>,
        Aaron Durbin <adurbin@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, David Hendrix <dhendrix@chromium.org>,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Exporting DMI entries via sysfs
Message-ID: <20110225200313.GA20028@kroah.com>
References: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 05:53:07PM -0800, Mike Waychison wrote:
> This patchset applies to v2.6.38-rc6.
> 
> The following series exports information the DMI / SMBIOS tables via
> sysfs under the path /sys/firmware/dmi.

Looks good, all queued up now, thanks for following through with this.

greg k-h
