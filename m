Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab2AESWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:22:49 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35120 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2AESWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:22:48 -0500
Date: Thu, 5 Jan 2012 18:22:45 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
        Thomas Renninger <trenn@suse.de>, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] ACPI: EC: Add ec_get_handle()
Message-ID: <20120105182245.GC24242@srcf.ucam.org>
References: <1325617358-8286-1-git-send-email-seth.forshee@canonical.com>
 <1325617358-8286-2-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325617358-8286-2-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 01:02:35PM -0600, Seth Forshee wrote:
> toshiba_acpi needs to execute an AML method within the EC namespace
> to make hotkeys work on some platforms. Provide an interface to
> allow it to easily get a handle to the EC namespace for this purpose.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Looks good to me - Len, do you want to take this through your tree or 
should I?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
