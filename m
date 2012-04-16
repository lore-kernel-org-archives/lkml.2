Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab2DPQJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:09:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45878 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab2DPQJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:09:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: [linux-pm] "i8042: Can't reactivate AUX port" after s2ram on 3.4-rc2
Date: Mon, 16 Apr 2012 18:14:12 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com> <201204152030.23148.rjw@sisk.pl> <1334553341.70819.YahooMailNeo@web161806.mail.bf1.yahoo.com>
In-Reply-To: <1334553341.70819.YahooMailNeo@web161806.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204161814.12441.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 16, 2012, Mikko Vinni wrote:
> From: Rafael J. Wysocki
> 
> >
> > Do you still have the kernel where all PCI devices worked correctly after system
> > resume?
> 
> If you are talking about https://bugzilla.kernel.org/show_bug.cgi?id=35452,
> I am not aware of such a kernel. That bug has existed for as long as I have
> cared to test.

OK, let's try to debug it a bit more in the Bugzilla entry.

> Testing the patch v4 soon.

Thanks!
