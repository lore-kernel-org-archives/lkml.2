Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab1K0JcB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 04:32:01 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38888 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878Ab1K0Jb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 04:31:59 -0500
X-Sasl-enc: y4nmojqPWf5wcH9BWI+o3sUD+BWUZVhIEfxIG0B7zrS1 1322386316
Date: Sat, 26 Nov 2011 17:07:00 -0800
From: Greg KH <greg@kroah.com>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] Split psb_intel_output to encoders and connectors
Message-ID: <20111127010700.GA1037@kroah.com>
References: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 12:02:05AM +0200, Patrik Jakobsson wrote:
> This set of patches gets rid of the pairing of encoders and connectors we had
> in psb_intel_output. This was done to make life easier getting the SDVO code
> from i915 copied into our tree (included in this patchset). It also gives more
> flexibility for better output handling in the future.
> 
> SDVO can now properly setup DDC and get EDID on the Fit-PC2 DVI connector but
> there are known issues when setting resolutions at 1920x1080 and above.
> On Asus 1201HA the VGA connector still fails to get EDID so more work is needed.
> 
> The changes to Cedarview, Moorestown and Medfield have not been tested so they
> are subject to change. Particularly the changes to Medfield are known not to be
> complete so more pondering is also needed there.

I need an ack from Alan before I can take this series.

thanks,

greg k-h
