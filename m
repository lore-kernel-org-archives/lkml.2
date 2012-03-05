Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab2CEWEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:04:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38780 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab2CEWEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:04:11 -0500
Date: Mon, 5 Mar 2012 16:04:07 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] toshiba_acpi: Expanded hotkey support
Message-ID: <20120305220407.GA16312@ubuntu-macmini>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-acpi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
	Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
References: <1326915852-19896-1-git-send-email-seth.forshee@canonical.com>
 <20120206150658.GE6414@ubuntu-macmini>
 <20120206151548.GA30255@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206151548.GA30255@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 03:15:48PM +0000, Matthew Garrett wrote:
> On Mon, Feb 06, 2012 at 09:06:58AM -0600, Seth Forshee wrote:
> 
> > Matthew: Just wondering if there are more issues that need to be
> > addressed with this round of patches, or if they're looking okay at this
> > point.
> 
> I'm fine with them at this point, just waiting on Len to give feedback 
> on the ACPI patch.

Well, I've been trying to get some comment on the ACPI patch, to no
avail. Unless there's some other option, I guess I'll just resend the
patches using an alternative method for getting the EC handle.

Seth
