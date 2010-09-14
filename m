Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab0INObY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:31:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39397 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab0INObY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:31:24 -0400
Message-ID: <45864.91.60.148.9.1284474680.squirrel@www.firstfloor.org>
Date: Tue, 14 Sep 2010 16:31:20 +0200 (CEST)
Subject: Re: [RFC 5/6] x86, NMI,
      Add support to notify hardware error with unknown NMI
From: "Andi Kleen" <andi@firstfloor.org>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Don Zickus" <dzickus@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
        "Huang Ying" <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> The proper approach would be not to add hacks to the NMI code but to
> implement southbridge drivers - which would also have NMI callbacks.

BTW southbridges do less and less regarding PCI.

> These are unchartered waters, but variance in that space is reducing
> systematically so it would be worth a shot.

You don't really need special drivers for AER -- it's fully standardized
and works generically. I think the old PCI-X error bits Don was interested
in were also all architectural.

The driver for the first is already there, just right now the
information is not dumped in the right places.

There are a few platform specific error signals, but they tend
to be rather obscure stuff. The "meat" is all in the standard.

-Andi

