Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab2FXT4I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 15:56:08 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:37657 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab2FXT4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 15:56:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 2/5] thinkpad_acpi: Use struct dev_pm_ops instead of legacy PM routines
Date: Sun, 24 Jun 2012 22:01:32 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: platform-driver-x86@vger.kernel.org,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Joey Lee <jlee@novell.com>
References: <201206172226.42729.rjw@sisk.pl> <201206172227.57189.rjw@sisk.pl> <20120624003416.GB20885@khazad-dum.debian.net>
In-Reply-To: <20120624003416.GB20885@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206242201.32250.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 24, 2012, Henrique de Moraes Holschuh wrote:
> On Sun, 17 Jun 2012, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Make the thinkpad_acpi driver define its PM callbacks through
> > a struct dev_pm_ops object rather than by using legacy PM hooks
> > in struct platform_driver.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

Thanks (and for the other patch too)!

Rafael
