Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab0H0BnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 21:43:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54339 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab0H0BnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 21:43:06 -0400
Date: Fri, 27 Aug 2010 02:42:59 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_ips: quieten "power or thermal limit exceeded"
	messages
Message-ID: <20100827014259.GB24636@srcf.ucam.org>
References: <4C74686D.8090707@cesarb.net> <1282865341-17607-1-git-send-email-cesarb@cesarb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282865341-17607-1-git-send-email-cesarb@cesarb.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree that something like this is needed, but I'm happy to defer to 
Jesse in terms of the implementation (he has the specs, I don't...). I'm 
also about to head offline for a week, so feel free to push the patch 
once you've got a solution and if I disagree with it I'll write whiny 
emails once I get back.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
