Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423026Ab2CPPhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:37:35 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41267 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031171Ab2CPPhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:37:33 -0400
Date: Fri, 16 Mar 2012 15:37:30 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] apple_bl: Add register/unregister functions
Message-ID: <20120316153730.GA2399@srcf.ucam.org>
References: <1331847128-16339-1-git-send-email-seth.forshee@canonical.com>
 <1331847128-16339-2-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331847128-16339-2-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 04:32:07PM -0500, Seth Forshee wrote:

> +extern int apple_bl_register(void);
> +extern void apple_bl_unregister(void);
> +
> +#endif

Ideally you'd provide stub functions here so gmux can be built even if 
apple_bl isn't.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
