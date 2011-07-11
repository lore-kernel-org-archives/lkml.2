Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964876Ab1GKTjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:39:10 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53999 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964832Ab1GKTjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:39:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAFR8uefOCHxcyQJb3hSmjM9oWeLgvRzUbUG-Y6qOBwr6Lmk=ig@mail.gmail.com>
References: <CANudz+sqkachOT7r9=-rc98nCEO_QOCx7KiBi5=NWaj5exmEPA@mail.gmail.com>
	<CANudz+vxY_0NY2veJ9Wvr08x_z3e20m=g7ZL4bZDi=-vaOF7dQ@mail.gmail.com>
	<4E1B3816.2030606@genband.com>
	<CANudz+vvXrw=4+tk6z8GW+2rW-ZsogN0XGcozLSyY-dJ_SoHdw@mail.gmail.com>
	<CAFR8uefOCHxcyQJb3hSmjM9oWeLgvRzUbUG-Y6qOBwr6Lmk=ig@mail.gmail.com>
Date: Tue, 12 Jul 2011 03:39:05 +0800
Message-ID: <CANudz+uMcN=P78QGV38_X8-m0dzk8g2NHgt2Gejoe1rB47bR8Q@mail.gmail.com>
Subject: Re: how to find a task through name faster?
From: loody <miloody@gmail.com>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Chris Friesen <chris.friesen@genband.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi:

2011/7/12 Muthu Kumar <muthu.lkml@gmail.com>:
> Let me ask a trivial question: Should this be done in kernel? Can't
> you push it to user space and walk the /proc to find if the process is
> there.
The root file system is fixed, that means I cannot add any program as I want.
BTW, will that be faster is run a user mode program to walk through /proc?
it still need to search one by one, right?
Thanks for your reply.
BR,
