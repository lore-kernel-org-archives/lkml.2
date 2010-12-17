Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0LQWW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 17:22:28 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:38530 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752Ab0LQWW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 17:22:27 -0500
Date: Fri, 17 Dec 2010 22:22:20 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "rydberg@euromail.se" <rydberg@euromail.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 1/2] applesmc: Use PnP rather than hardcoding resources
	and devices
Message-ID: <20101217222220.GA11564@srcf.ucam.org>
References: <20101216170018.GA8140@ericsson.com> <1292623106-31684-1-git-send-email-mjg@redhat.com> <20101217221618.GA13207@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101217221618.GA13207@ericsson.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 02:16:18PM -0800, Guenter Roeck wrote:
> > +
> Those variables are still global.

I do appear to suck.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
