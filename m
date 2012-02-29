Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab2B2Rxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:53:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47346 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503Ab2B2Rxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:53:31 -0500
Date: Wed, 29 Feb 2012 11:53:27 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] platform/x86: Add driver for Apple gmux device
Message-ID: <20120229175327.GA20565@ubuntu-macmini>
Mail-Followup-To: Grant Likely <grant.likely@secretlab.ca>,
	Matthew Garrett <mjg@redhat.com>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1329424465-1211-1-git-send-email-seth.forshee@canonical.com>
 <1329921457-26887-1-git-send-email-seth.forshee@canonical.com>
 <CACxGe6sAcubJvc6LaVRxt+XzBz0jKpxSAPLdOvXkQz=NkXG5vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6sAcubJvc6LaVRxt+XzBz0jKpxSAPLdOvXkQz=NkXG5vQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 11:46:39AM -0600, Grant Likely wrote:
> On Wed, Feb 22, 2012 at 8:37 AM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> > Apple laptops with hybrid graphics have a device named gmux that
> > controls the muxing of the LVDS panel between the GPUs as well as screen
> > brightness. This driver adds support for the gmux device. Only backlight
> > control is supported initially.
> >
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> 
> Works for me.
> 
> Tested-by: Grant Likely <grant.likely@secretlab.ca>
> 
> Now I just need to figure out how to get the desktop backlight widget
> to use gmux_backlight instead of acpi_video0...

The easy way is to pass acpi_backlight=vendor to the kernel, then you
won't have acpi_vidoe0.

Seth
