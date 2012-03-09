Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab2CISG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:06:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58525 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab2CISG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:06:57 -0500
Date: Fri, 9 Mar 2012 12:06:52 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] Expanded hotkey support
Message-ID: <20120309180652.GA22150@ubuntu-macmini>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	platform-driver-x86@vger.kernel.org,
	Azael Avalos <coproscefalo@gmail.com>,
	Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
References: <20120305220407.GA16312@ubuntu-macmini>
 <1331004633-11862-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331004633-11862-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
> 
> Thanks,
> Seth

Matthew, do these look okay for 3.4 now that there's no dependency on
changing the EC driver?

Thanks,
Seth

