Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab0KXQxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:53:51 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37374 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab0KXQxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:53:49 -0500
Date: Wed, 24 Nov 2010 16:53:43 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Colin King <colin.king@canonical.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] WMI: Cater for multiple events with same GUID
Message-ID: <20101124165343.GK2150@srcf.ucam.org>
References: <1290181202-9439-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290181202-9439-1-git-send-email-colin.king@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've applied this to -next - is there anything that needs this that 
would benefit from it in .37?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
