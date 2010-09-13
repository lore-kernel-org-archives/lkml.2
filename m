Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab0IMPaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:30:07 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:41090 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab0IMPaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:30:06 -0400
Message-ID: <4C8E437B.1060103@xs4all.nl>
Date: Mon, 13 Sep 2010 17:30:03 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: hpet timers gone?
References: <4BFA52C3.4080006@xs4all.nl>	<20100526120236.4a849b5b.randy.dunlap@oracle.com>	<4C021507.6020703@xs4all.nl>	<4C02B3AB.3040405@gmail.com>	<4C0324B8.8070304@xs4all.nl> <AANLkTikuaPxA9Xnzc1bCJ5YHRlPZ1AcBSrYJ5lqryaMY@mail.gmail.com> <4C8E3ABF.90309@xs4all.nl>
In-Reply-To: <4C8E3ABF.90309@xs4all.nl>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-13 16:52, Udo van den Heuvel wrote:
> On 2010-05-31 06:00, Robert Hancock wrote:
>> If they did add an HPET table entry, it should help, yes..
> 
> Is there a workaround?
> VIA was not so helpfull: the bios flash tool they have on the site does
> not recognise the board as a VIA board.
> Also they state the latest BIOS will not add HPET to ACPI table.

Could I adapt the old patch for 8237 to force-enable HPET?

If so: I might need to find out in what ways the C700X2 and VT8237
differ w.r.t. HPET and/or id. Anyone here that could help?

Or should blindly enabling HPET (as in VT8237) help?

Udo
