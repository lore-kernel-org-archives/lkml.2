Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab1K3Vje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 16:39:34 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63930 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab1K3Vjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 16:39:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAGPN=9Q8gB_xsbB1BrMJSo_Qs=7Tu49RX4x3VqNB9adzVdm6kg@mail.gmail.com>
References: <CAGPN=9Q8gB_xsbB1BrMJSo_Qs=7Tu49RX4x3VqNB9adzVdm6kg@mail.gmail.com>
Date: Wed, 30 Nov 2011 22:39:32 +0100
Message-ID: <CAGPN=9RN8bKX_4gU5yFbksp2g6Qt34gkoKjx8XLCon-UCbOdaw@mail.gmail.com>
Subject: Re: i915: RC6 causes sudden shutdowns
From: Patrik Kullman <patrik.kullman@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So is this being worked on already?

It would be wonderful to get this fixed since it gives additional
hours of battery life, but it's currently unusable for my this
machine.

2011/11/24 Patrik Kullman <patrik.kullman@gmail.com>:
> Hi,
>
> I recently acquired the Asus Zenbook UX31E but have been looking for
> ways to extend the battery life.
>
> I read that the i915_enable_rc6 parameter could decrease power usage
> significantly and tried it with the 3.1.1 and 3.1.2 kernels, and
> indeed it does.
> However, I (and the other Zenbook-owners from the Ubuntu forums)
> experience sudden, unexpected shutdowns (for me, 1-4 times per day)
> with this parameter.
> It's as sudden as a power loss.
>
> It happens both when pcie_aspm=force is supplied and when it's not.
> What also is a bit concerning is that I read that RC6 is going to be
> enabled by default from 3.2 onward?
>
> How would we go about troubleshooting this?
>
> Or is the only option to blacklist the machine from RC6 if it doesn't
> work as is?
