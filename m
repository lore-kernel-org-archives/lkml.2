Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab2GGTCW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 15:02:22 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63243 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2GGTCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 15:02:20 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1207070017440.13732@info>
References: <Pine.LNX.4.64.1205311412210.11510@info>
	<CAErSpo7p6XGmsi0Q0PAbWofs9-91taz2Px=VxzL2KEoWWYJwSA@mail.gmail.com>
	<Pine.LNX.4.64.1206010915580.26561@info>
	<4FC988CF.5030602@gmail.com>
	<20120706180635.GB17196@google.com>
	<Pine.LNX.4.64.1207061631270.26974@info>
	<CAE9FiQV5DHZoeXf-bSfuYGUSzmwtdVqGNfhHh7LJ3LBax++Rig@mail.gmail.com>
	<Pine.LNX.4.64.1207070017440.13732@info>
Date: Sat, 7 Jul 2012 12:02:19 -0700
X-Google-Sender-Auth: CXa-erFzAukYWD0C97O7-sbb_vY
Message-ID: <CAE9FiQVDW23eLzjNk6ibGq+8KAG9kC2=7g-Eh6p0k3GrxG0LmQ@mail.gmail.com>
Subject: Re: [Bug 43331] Re: Bug on bootup of Linux kernel on Panasonic
 Toughbook S10
From: Yinghai Lu <yinghai@kernel.org>
To: Bill Unruh <unruh@physics.ubc.ca>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 7, 2012 at 12:22 AM, Bill Unruh <unruh@physics.ubc.ca> wrote:
> On Fri, 6 Jul 2012, Yinghai Lu wrote:
> Where would I get a new BIOS ? Has Panasonic released a bios update for this
> machine that fixes this problem?

looks like they do not bios update for S10 yet.

http://www.panasonic.com/business/toughbook/computer-support-bios.asp#CF-U1

maybe you can try to email or call their support.

>
> I guess the other possibility is to live with the error message, or is this
> error part of the reason why my machine has such bad battery use? (less than
> 1/2 the time that Windows gets on the same machine).

not sure, You can try to boot with pci=nocrs to see if there is any difference.

Thanks

Yinghai
