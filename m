Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab2CPV1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:27:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60401 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab2CPV1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:27:39 -0400
Date: Fri, 16 Mar 2012 16:27:35 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 2/2] platform/x86: Add driver for Apple gmux device
Message-ID: <20120316212735.GD25984@ubuntu-macmini>
Mail-Followup-To: Matthew Garrett <mjg@redhat.com>,
	platform-driver-x86@vger.kernel.org,
	Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
	Grant Likely <grant.likely@secretlab.ca>
References: <1331926882-22979-1-git-send-email-seth.forshee@canonical.com>
 <1331926882-22979-3-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331926882-22979-3-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 02:41:22PM -0500, Seth Forshee wrote:
> Apple laptops with hybrid graphics have a device named gmux that
> controls the muxing of the LVDS panel between the GPUs as well as screen
> brightness. This driver adds support for the gmux device. Only backlight
> control is supported initially.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Looks like I forgot to add Grant's tested-by from the v2 patch. Matthew,
if you pick up this version will you add it? Otherwise I include it in
the next round.

Tested-by: Grant Likely <grant.likely@secretlab.ca>
