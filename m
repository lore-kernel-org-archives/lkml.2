Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab0DTTAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 15:00:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52725 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab0DTTAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 15:00:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] ACPI: DMI init_set_sci_en_on_resume for multiple Lenovo ThinkPads
Date: Tue, 20 Apr 2010 21:01:10 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Jerone Young <jerone.young@canonical.com>,
       Alex Chiang <achiang@canonical.com>, lenb@kernel.org,
       colin.king@canonical.com, linux-acpi@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org
References: <20100420140314.GA5573@canonical.com> <1271783936.25170.131.camel@laptop> <20100420172419.GA9719@srcf.ucam.org>
In-Reply-To: <20100420172419.GA9719@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004202101.10245.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 April 2010, Matthew Garrett wrote:
> On Tue, Apr 20, 2010 at 12:18:56PM -0500, Jerone Young wrote:
> 
> > I could agree, but the only issue is if you go to the thinkpad-acpi or
> > ibm-acpi mailing list they would probably disagree as there have been
> > updates to the bios in the past required for proper functionality of
> > Thinkpads ;-) .. the bios update methods have not changed since then for
> > Thinkpads.
> 
> If another OS works, and if Linux can be made to work without impairing 
> the functionality of working machines, then Linux should be made to 
> work. Always. Updating the BIOS should be limited to cases where it's 
> impossible to fix things up in the OS.

Agreed.

Rafael
