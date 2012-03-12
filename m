Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab2CLOG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 10:06:58 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40797 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2CLOG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 10:06:56 -0400
Date: Mon, 12 Mar 2012 14:06:52 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, Azael Avalos <coproscefalo@gmail.com>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
        lenb@kernel.org
Subject: Re: [PATCH v4 0/3] Expanded hotkey support
Message-ID: <20120312140652.GA11375@srcf.ucam.org>
References: <20120305220407.GA16312@ubuntu-macmini>
 <1331004633-11862-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331004633-11862-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 09:30:30PM -0600, Seth Forshee wrote:
> New version of the patches which remove the need to modify the EC
> driver.
> 
> Changes since v3:
> 
>  * Drop patch to add ec_get_handle()
>  * Use acpi_get_devices() to get EC handle

I'm not thrilled by this. I think making the change in the ec driver is 
the appropriate thing to do rather than duplicating this code elsewhere 
- Len, what's the holdup in merging that?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
