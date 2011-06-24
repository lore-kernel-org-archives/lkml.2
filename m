Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1FXQ4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 12:56:17 -0400
Received: from openfortress.nl ([213.189.19.244]:56382 "EHLO fame.vanrein.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751308Ab1FXQ4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 12:56:15 -0400
Date: Fri, 24 Jun 2011 16:56:12 +0000
From: Rick van Rein <rick@vanrein.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rick van Rein <rick@vanrein.org>,
        Craig Bergstrom <craigb@google.com>, Andi Kleen <andi@firstfloor.org>,
        Stefan Assmann <sassmann@kpanic.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Message-ID: <20110624165612.GC31887@phantom.vanrein.org>
References: <20110623133950.GB28333@srcf.ucam.org> <4E0348E0.7050808@kpanic.de> <20110623141222.GA30003@srcf.ucam.org> <4E035DD1.1030603@kpanic.de> <20110623170014.GN3263@one.firstfloor.org> <987664A83D2D224EAE907B061CE93D5301E938F2FD@orsmsx505.amr.corp.intel.com> <BANLkTikTTCU3eKkCtrbLbtpLJtksehyEMg@mail.gmail.com> <20110624080535.GA19966@phantom.vanrein.org> <4E04B848.6000908@zytor.com> <987664A83D2D224EAE907B061CE93D5301E942ED99@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301E942ED99@orsmsx505.amr.corp.intel.com>
X-My-Coolest-Hack: http://rick.vanrein.org/linux/badram -> Exploit broken RAM
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Does it scale? [...] Perhaps we may end up with a composite solution. 

If I had my way, there would be an extension to the e820 format to allow
the BadRAM patterns to be specified.  Since the extension with bad page
information is specific to boot loader interaction, this would work in
exactly those cases that are covered by the current situation.

-Rick
