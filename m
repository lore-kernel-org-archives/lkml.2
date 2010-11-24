Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0KXQ5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:57:43 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:56974 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab0KXQ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:57:41 -0500
Date: Wed, 24 Nov 2010 16:57:35 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Colin Ian King <colin.king@canonical.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] WMI: Cater for multiple events with same GUID
Message-ID: <20101124165735.GA2710@srcf.ucam.org>
References: <1290181202-9439-1-git-send-email-colin.king@canonical.com> <20101124165343.GK2150@srcf.ucam.org> <1290617793.1872.1.camel@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290617793.1872.1.camel@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 04:56:33PM +0000, Colin Ian King wrote:
> I'm preparing a WMI driver that will use this - I will submit this in
> the next few days.

Ok, were you thinking .37 or .38 for that?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
