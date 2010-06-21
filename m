Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab0FUM1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 08:27:43 -0400
Received: from ist.d-labs.de ([213.239.218.44]:58851 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995Ab0FUM1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 08:27:39 -0400
Date: Mon, 21 Jun 2010 14:26:58 +0200
From: Florian Mickler <florian@mickler.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Newsgroups: gmane.linux.power-management.general,gmane.linux.kernel
Cc: tytso@mit.edu, mark gross <640e9920@gmail.com>, markgross@thegnar.org,
       Neil Brown <neilb@suse.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Message-ID: <20100621142658.365493ae@schatten.dmk.lab>
In-Reply-To: <20100621132234.5eb880b0@lxorguk.ukuu.org.uk>
References: <201006202350.27143.rjw@sisk.pl>
	<Pine.LNX.4.44L0.1006202154260.29532-100000@netrider.rowland.org>
	<20100621061345.GF9735@gvim.org>
	<20100621121058.GF6199@thunk.org>
	<20100621132234.5eb880b0@lxorguk.ukuu.org.uk>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 13:22:34 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > How do we go forward from here?
> 
> PM QoS seems to be evolving nicely.

Still, it doesn't solve the userspace-part.

Cheers,
Flo
