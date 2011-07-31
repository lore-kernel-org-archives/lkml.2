Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1GaRAk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 13:00:40 -0400
Received: from lunge.queued.net ([173.255.254.236]:58841 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab1GaRAf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 13:00:35 -0400
Date: Sun, 31 Jul 2011 10:00:32 -0700
From: Andres Salomon <dilinger@queued.net>
To: Daniel Drake <dsd@laptop.org>
Cc: David Woodhouse <dwmw2@infradead.org>, cjb@laptop.org,
        linux-kernel@vger.kernel.org, dcbw@redhat.com,
        libertas-dev@lists.infradead.org
Subject: Re: [GIT PULL linux-firmware.git] OLPC libertas firmware blobs
Message-ID: <20110731100032.5f9155eb@debxo>
In-Reply-To: <CAGq3pz4sbLxRz3AnQZehUpseDhGNY7Wi03Mce-w=Ex4uGy3x8w@mail.gmail.com>
References: <20110730225039.34467e4e@debxo>
	<CAGq3pz4sbLxRz3AnQZehUpseDhGNY7Wi03Mce-w=Ex4uGy3x8w@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Jul 2011 13:58:20 +0100
Daniel Drake <dsd@laptop.org> wrote:

> On 31 July 2011 06:50, Andres Salomon <dilinger@queued.net> wrote:
> >  libertas/usb8388_v5.bin |  Bin 100292 -> 127824 bytes
> 
> It looks like you're replacing the generic Marvell v5 firmware with
> the OLPC-forked version. Technically these are independent branches,
> so it would make more sense to have the OLPC one separately e.g.
> usb8388_olpc_v5.bin.
> 

I guess I misunderstood.  I thought since dcbw was saying OLPC was the
only real user of the chip, so it didn't matter; in my mind, that
mean just replace v5 (since it's a superset of functionality
anyways).

