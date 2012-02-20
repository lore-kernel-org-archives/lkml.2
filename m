Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab2BTWGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 17:06:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33139 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab2BTWGt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 17:06:49 -0500
MIME-Version: 1.0
In-Reply-To: <20120220212323.GE3538@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1329768563-13715-1-git-send-email-computersforpeace@gmail.com>
	<1329768563-13715-2-git-send-email-computersforpeace@gmail.com>
	<20120220205115.GA3538@dhcp-172-17-108-109.mtv.corp.google.com>
	<CAN8TOE8Jgje7kjpZ-bsoObs-kbYYjwwDVEeN-K7ExMq5NuR4tQ@mail.gmail.com>
	<20120220212323.GE3538@dhcp-172-17-108-109.mtv.corp.google.com>
Date: Mon, 20 Feb 2012 14:06:49 -0800
Message-ID: <CAN8TOE9+RR_cBLTzZCYVbf0T0a_5sBWxrj11ZdJTQ7GJ4yMi0g@mail.gmail.com>
Subject: Re: [PATCH 1/3] ahci: add AHCI_HFLAG_STRICT_SPEC host flag
From: Brian Norris <computersforpeace@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Norbert Preining <preining@logic.at>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        "Rafael J . Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 1:23 PM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Feb 20, 2012 at 01:16:27PM -0800, Brian Norris wrote:
>> On Mon, Feb 20, 2012 at 12:51 PM, Tejun Heo <tj@kernel.org> wrote:
>> > Overall the patchset looks good but
>> >
>> > On Mon, Feb 20, 2012 at 12:09:21PM -0800, Brian Norris wrote:
>> >> +     AHCI_HFLAG_STRICT_SPEC          = (1 << 15), /* strict AHCI spec */
>> >
>> > can you please use something more specific?  e.g. something like
>> > SKIP_ENGINE_ON_PORT_START and then explain what the flag is about in
>> > the comment?
>>
>> So you want AHCI_HFLAG_SKIP_ENGINE_ON_PORT_START? That seems
>> excessively long... how about AHCI_HFLAG_DELAY_ENGINE? (since it
>> pushes the start engine call back to the error-handling stage)
>
> Ooh, yeah, that seems better.  I'm fine with any name which ties it to
> engine behavior on port start.

OK. I'll wait a bit for other comments, then send a v2 series with
AHCI_HFLAG_DELAY_ENGINE.

Brian
