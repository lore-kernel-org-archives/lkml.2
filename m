Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab2DACeg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 22:34:36 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:6482 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754056Ab2DACe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 22:34:29 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zz1432N98dK4015Izz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1S4HA-01-67K-02
X-M-MSG: 
Date: Sun, 1 Apr 2012 18:34:09 +0800
From: Aaron Lu <aaron.lu@amd.com>
To: Jan Ceuleers <jan.ceuleers@computer.org>
CC: Alan Stern <stern@rowland.harvard.edu>, Lin Ming <ming.m.lin@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
Message-ID: <20120401103408.GA2815@localhost.amd.com>
References: <CAOzJMDRajsjHwCC66XB6Mv-Deuy-wD4GiZbeuEqCQePSLw-Xxw@mail.gmail.com>
 <Pine.LNX.4.44L0.1203291050580.1417-100000@iolanthe.rowland.org>
 <20120330010730.GA27346@ladygaga>
 <4F76E054.8010301@computer.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F76E054.8010301@computer.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 01 Apr 2012 02:34:16.0261 (UTC) FILETIME=[EEBC1750:01CD0FAF]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 12:45:40PM +0200, Jan Ceuleers wrote:
> 
> What about slot-loading optical drives, where the user does not
> first have to press a button to open the tray (due to a lack of
> tray)?

For slot type ODD, the insert of a disk will fire the gpe event by
means of the sata slimline connector's device attention pin.

That means, the insert of a disk into a slot type ODD and the
press of the eject button of a tray type ODD has the same effect to
trigger the resume process.

Thanks,
Aaron


