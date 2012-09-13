Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab2IMU0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 16:26:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48622 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab2IMU0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:26:18 -0400
Date: Thu, 13 Sep 2012 15:26:14 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] gmux: Fix backlight set function
Message-ID: <20120913202614.GA26996@thinkpad-t410>
Mail-Followup-To: Grant Likely <grant.likely@secretlab.ca>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Garrett <mjg@redhat.com>
References: <1347566555-9388-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347566555-9388-1-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 09:02:35PM +0100, Grant Likely wrote:
> In commit 7e30ed6b, "gmux: Add generic write32 function", the new
> gmux_write32() function didn't include the io offset when writing
> registers. This means that backlight update writes never go to the right
> place. This patch fixes it.
> 
> Tested on Apple Macbook 8,3
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Matthew Garrett <mjg@redhat.com>

I sent a patch for this several weeks ago [1], just waiting for Matthew
to pick it up.

Seth

[1] https://lkml.org/lkml/2012/8/21/721

