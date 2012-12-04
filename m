Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab2LDPep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:34:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:23575 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab2LDPen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:34:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="228802726"
Date: Tue, 4 Dec 2012 15:37:16 +0000
From: Alan Cox <alan@linux.intel.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [char-misc-next 07/15] mei: use wrietl/readl instead of io
 wrappers
Message-ID: <20121204153716.322b2cc7@bob.linux.org.uk>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B01E9DED6@HASMSX106.ger.corp.intel.com>
References: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
	<1354629884-3202-7-git-send-email-tomas.winkler@intel.com>
	<20121204143151.1cce530a@pyramind.ukuu.org.uk>
	<5B8DA87D05A7694D9FA63FD143655C1B01E9DED6@HASMSX106.ger.corp.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > so you need to tweak the map/unmap if you do this.
> > 
> > As to overhead. I'd love to see a measurement that can detect the
> > difference. Do you have a benchmark that shows it ?
> 
> Don't have any numbers but it seems reasonable to me.

Processors are pretty good at prediction these days. I've not seen any
evidence to support the assumption.

