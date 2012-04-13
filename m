Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab2DMPdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 11:33:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64147 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab2DMPdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 11:33:39 -0400
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Fri, 13 Apr 2012 17:33:17 +0200
Message-ID: <CAH9NwWeOt3bbcpP98Q6A2iKSZwqD628iHHAgr_Oe-UgKkE=G5A@mail.gmail.com>
Subject: pata_cs5536: DMI detection of broken PCs
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have here some devices, which are using pata_cs5536. The big problem
is now that some of
the eary hardware revision have a bug that makes it impossible to use
UDMA with UDMA capable
devices. This problem got fixed and the newest hardware revision has
working UDMA support.
The big problem is that there are devices sold - years ago - which
suffer from this UDMA problem.
Now it would be possible for the customer to switch from vxworks to
linux but if the device hangs
with UDMA capable devices the customer will not be very happy :)

Is there a way to backlist the old devices to not use UDMA at all? DMI
would be a good idea for
detecting old devices. Is something like this possible?

---
Christian Gmeiner, MSc
