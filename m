Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1BWNrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:47:53 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35473 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab1BWNrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:47:52 -0500
Date: Wed, 23 Feb 2011 13:47:48 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ike Panhc <ike.pan@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ideapad: read brightness setting on brightness key
	notify
Message-ID: <20110223134748.GA6830@srcf.ucam.org>
References: <1298468399-3642-1-git-send-email-ike.pan@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298468399-3642-1-git-send-email-ike.pan@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 09:39:59PM +0800, Ike Panhc wrote:
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=25922
> 
> On ideapad Y530, the brightness key notify will be blocked if the last notify
> is not responsed by getting the brightness value. Read value when we get the
> notify shall fix the problem and will not have any difference on other ideapads.

Which kernel versions does this hit?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
