Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab1GVUlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 16:41:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56053 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab1GVUlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 16:41:16 -0400
MIME-Version: 1.0
In-Reply-To: <20110722094126.GI2622@htj.dyndns.org>
References: <CAN8TOE9CCSiS2koyx=UsZj=9KwaWZW5yDjUUqgJf2=qZU70k1w@mail.gmail.com>
	<20110713131407.GN2872@htj.dyndns.org>
	<CAN8TOE9Rjujf9aLQGONDULNasFiQmVkiUPWUDX=Vf0Nx2pka7w@mail.gmail.com>
	<20110721084917.GE3455@htj.dyndns.org>
	<CAN8TOE_dCg6Wi_trE97hXjBPnZi4jpLyoeUEVrbMpgDH-BwKWA@mail.gmail.com>
	<20110722090317.GH2622@htj.dyndns.org>
	<20110722094126.GI2622@htj.dyndns.org>
Date: Fri, 22 Jul 2011 13:41:14 -0700
Message-ID: <CAN8TOE_Gd1TdFNFAf6dTQrkzLQbdJstXGqnqrs1tbzX8hgrzhQ@mail.gmail.com>
Subject: Re: [PATCH #upstream] ahci: start engine only during soft/hard resets
From: Brian Norris <computersforpeace@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Valdis.Kletnieks@vt.edu, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Michael Leun <lkml20100708@newton.leun.net>,
        linux-kernel@vger.kernel.org, Jian Peng <jipeng2005@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 2:41 AM, Tejun Heo <tj@kernel.org> wrote:
> This is another attempt at fixing the same problem that 270dac35c2
> (libata: ahci_start_engine compliant to AHCI spec) tried to solve.
> Unfortunately, 270dac35c2 created regressions for a lot more common
> controllers and got reverted.

I've tested this on my problem controller with success so far. Also
tried on Dell Latitude E6410 (with various boot, suspend, resume,
unplug power, etc. cycles) with no problem. Thanks Tejun!

In case it's useful I'll give a tested-by:

Tested-by: Brian Norris <computersforpeace@gmail.com>
