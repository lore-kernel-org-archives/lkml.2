Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300Ab2GGHW0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 03:22:26 -0400
Received: from info.physics.ubc.ca ([142.103.234.23]:44976 "EHLO
	info.physics.ubc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab2GGHWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 03:22:24 -0400
Date: Sat, 7 Jul 2012 00:22:24 -0700 (PDT)
From: Bill Unruh <unruh@physics.ubc.ca>
X-X-Sender: unruh@info
To: Yinghai Lu <yinghai@kernel.org>
cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 43331] Re: Bug on bootup of Linux kernel on Panasonic
 Toughbook S10
In-Reply-To: <CAE9FiQV5DHZoeXf-bSfuYGUSzmwtdVqGNfhHh7LJ3LBax++Rig@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1207070017440.13732@info>
References: <Pine.LNX.4.64.1205311412210.11510@info>
 <CAErSpo7p6XGmsi0Q0PAbWofs9-91taz2Px=VxzL2KEoWWYJwSA@mail.gmail.com>
 <Pine.LNX.4.64.1206010915580.26561@info> <4FC988CF.5030602@gmail.com>
 <20120706180635.GB17196@google.com> <Pine.LNX.4.64.1207061631270.26974@info>
 <CAE9FiQV5DHZoeXf-bSfuYGUSzmwtdVqGNfhHh7LJ3LBax++Rig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2012, Yinghai Lu wrote:
>
> so try get one update bios that could return resource for root bus.
>
> or you could try to live with booting with pci=nocrs before your get new BIOS.

Where would I get a new BIOS ? Has Panasonic released a bios update for this
machine that fixes this problem?

I guess the other possibility is to live with the error message, or is this
error part of the reason why my machine has such bad battery use? (less than 
1/2 the time that Windows gets on the same machine).
