Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab1CUXlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:41:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51946 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab1CUXlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:41:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: Hot plug issue on 2.6.38
Date: Tue, 22 Mar 2011 00:41:50 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Yinghai Lu <yinghai@kernel.org>,
        linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>
References: <201103052254.48515.rjw@sisk.pl> <20110321223408.GA17412@srcf.ucam.org> <20110321233104.GA4334@xanatos>
In-Reply-To: <20110321233104.GA4334@xanatos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103220041.51154.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 22, 2011, Sarah Sharp wrote:
> On Mon, Mar 21, 2011 at 10:34:08PM +0000, Matthew Garrett wrote:
> > Try setting CONFIG_HOTPLUG_PCI_ACPI to y as well, just to rule that out?
> 
> It's set to build as a module, do you want me to compile it in?

Yes, if poss.  But as I said before, please make sure you have the ASPM patch
applied.

Rafael
