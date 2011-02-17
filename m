Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab1BQQeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:34:04 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51219 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab1BQQeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:34:02 -0500
Date: Thu, 17 Feb 2011 16:33:51 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Colin King <colin.king@canonical.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable Dell All-In-One volume up/down keys
Message-ID: <20110217163351.GB20662@srcf.ucam.org>
References: <1297688524-26123-1-git-send-email-colin.king@canonical.com> <20110217075256.GB19814@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217075256.GB19814@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 11:52:56PM -0800, Dmitry Torokhov wrote:

> Looks generally good, one question though - should't it be part of
> dell-wmi driver?

It uses a different WMI GUID and has a different behaviour model to dell 
laptops that dell-wmi drives, so I think it's fair for it to be a 
separate driver.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
