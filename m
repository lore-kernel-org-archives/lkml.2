Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab1GGPLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:11:38 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48147 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1GGPLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:11:35 -0400
Date: Thu, 7 Jul 2011 16:11:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Keng-Yu Lin <kengyu@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        ike.pan@canonical.com, vanhoof@canonical.com, kent.lin@canonical.com,
        sylee@canonical.com
Subject: Re: [PATCH 2/2] ideapad-laptop: Handle the App-controlled RF event
Message-ID: <20110707151118.GB15366@srcf.ucam.org>
References: <1309268154-6872-1-git-send-email-kengyu@canonical.com>
 <1309268154-6872-2-git-send-email-kengyu@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309268154-6872-2-git-send-email-kengyu@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 02:35:54PM +0100, Keng-Yu Lin wrote:

> On Linux, there is no such application. This patch implements
> a toggle for all RF devices through accessing the EC I/O ports.

Sure there is. Either the kernel can handle it via rfkill-input, or 
rfkilld can look after it. Please don't add your own implementation.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
