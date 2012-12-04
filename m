Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab2LDQEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 11:04:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:3924 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab2LDQD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 11:03:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="176029760"
Date: Tue, 4 Dec 2012 16:06:18 +0000
From: Alan Cox <alan@linux.intel.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [char-misc-next 07/15] mei: use wrietl/readl instead of io
 wrappers
Message-ID: <20121204160618.585ac53d@bob.linux.org.uk>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B01E9DF12@HASMSX106.ger.corp.intel.com>
References: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
	<1354629884-3202-7-git-send-email-tomas.winkler@intel.com>
	<20121204143151.1cce530a@pyramind.ukuu.org.uk>
	<5B8DA87D05A7694D9FA63FD143655C1B01E9DED6@HASMSX106.ger.corp.intel.com>
	<20121204153716.322b2cc7@bob.linux.org.uk>
	<5B8DA87D05A7694D9FA63FD143655C1B01E9DF12@HASMSX106.ger.corp.intel.com>
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

On Tue, 4 Dec 2012 16:02:17 +0000
"Winkler, Tomas" <tomas.winkler@intel.com> wrote:

> > > > As to overhead. I'd love to see a measurement that can detect
> > > > the difference. Do you have a benchmark that shows it ?
> > >
> > > Don't have any numbers but it seems reasonable to me.
> > 
> > Processors are pretty good at prediction these days. I've not seen
> > any evidence to support the assumption.
> 
> I don't have strong opinion about it, yet what would be benefit of
> keeping the io abstraction layer, In case we are sure it is not used
> with io ports?

Less changes to existing working code being the obvious one.

Alan
