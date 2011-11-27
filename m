Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab1K0KU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 05:20:26 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53596 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752494Ab1K0KUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 05:20:24 -0500
X-Sasl-enc: zc9NywuCrURfMxegOegCDjpx1TY9LOoQfO7Mjr52a4FA 1322389222
Date: Sat, 26 Nov 2011 20:20:30 -0800
From: Greg KH <greg@kroah.com>
To: Corentin Chary <corentincj@iksaif.net>
Cc: platform-driver-x86@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/16] samsung-laptop: don't handle backlight if
 handled by acpi/video
Message-ID: <20111127042030.GA17802@kroah.com>
References: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
 <1322301613-8801-4-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322301613-8801-4-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 11:00:00AM +0100, Corentin Chary wrote:
> samsung-laptop is not at all related to ACPI, but since this interface
> is not documented at all, and the driver has to use it at load to
> understand how it works on the laptop, I think it's a good idea to
> disable it if a better solution is available.
> 
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
