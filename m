Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab2CZOvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:51:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722Ab2CZOvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:51:32 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via initrd
Date: Mon, 26 Mar 2012 16:51:29 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.0; x86_64; ; )
Cc: eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <201203261619.31766.trenn@suse.de> <4F70812A.4080205@zytor.com>
In-Reply-To: <4F70812A.4080205@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203261651.29640.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 26, 2012 04:46:02 PM H. Peter Anvin wrote:
> On 03/26/2012 07:19 AM, Thomas Renninger wrote:
> > Do the names have to be fixed?
> 
> No, I assume it would "all files inside this namespace".
> 
> > If there is only one file where all ACPI table binaries are glued
> > together kernel/acpi_tables.binary.blob
> > my code should already work as good as unmodified.
> > 
> > Not sure what is best and whether anybody cares about how the tables
> > are layed out.
> > 
> > I guess I just wait until your functionality is in linux-next and
> > give it a closer look then and may come up with a new patch.
> 
> I doubt it will get into linux-next without a user.  If you have time to
> pull in the code I sent it will be quicker, otherwise I'll probably
> setup a git tree upon which things can be put.

I need some weeks to have time to revisit this.
But as it slips this merge window anyway it should not matter.
Please add me to CC if someone else looks at or goes on with this.

  Thomas
