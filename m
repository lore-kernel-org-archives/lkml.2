Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904Ab1FXQQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 12:16:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37177 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab1FXQQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 12:16:45 -0400
Message-ID: <4E04B848.6000908@zytor.com>
Date: Fri, 24 Jun 2011 09:16:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Rick van Rein <rick@vanrein.org>
CC: Craig Bergstrom <craigb@google.com>, "Luck, Tony" <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Stefan Assmann <sassmann@kpanic.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de> <20110623133950.GB28333@srcf.ucam.org> <4E0348E0.7050808@kpanic.de> <20110623141222.GA30003@srcf.ucam.org> <4E035DD1.1030603@kpanic.de> <20110623170014.GN3263@one.firstfloor.org> <987664A83D2D224EAE907B061CE93D5301E938F2FD@orsmsx505.amr.corp.intel.com> <BANLkTikTTCU3eKkCtrbLbtpLJtksehyEMg@mail.gmail.com> <20110624080535.GA19966@phantom.vanrein.org>
In-Reply-To: <20110624080535.GA19966@phantom.vanrein.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2011 01:05 AM, Rick van Rein wrote:
> 
> I am very curious about your findings.  Independently of those, I am in
> favour of a patch that enables longer e820 tables if it has no further
> impact on speed or space.
> 

That is already in the mainline kernel, although only if fed from the
boot loader (it was developed in the context of mega-NUMA machines); the
stub fetching from INT 15h doesn't use this at the moment.

	-hpa
