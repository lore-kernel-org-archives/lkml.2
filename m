Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab2IUO6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 10:58:05 -0400
Received: from fbsmtp.dnsalias.org ([82.66.248.156]:40628 "EHLO
	fbsmtp.dnsalias.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab2IUO6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 10:58:03 -0400
Date: Fri, 21 Sep 2012 16:57:53 +0200
From: =?ISO-8859-1?Q?Fran=E7ois?= Boisson 
	<user.anti-spam@maison.homelinux.net>
To: linux-kernel@vger.kernel.org
Subject: Re: shutdown with toshiba portege
Message-Id: <20120921165753.7a5701fc6a0e1445daa92500@maison.homelinux.net>
In-Reply-To: <20120920204234.0fb035a89f88a2e1f468aa54@maison.homelinux.net>
References: <20120920204234.0fb035a89f88a2e1f468aa54@maison.homelinux.net>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Scanner: exiscan *1TF4fy-0004PS-00*xnrZDucU3Rk*
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Thu, 20 Sep 2012 20:42:34 +0200
François Boisson  <user.anti-spam@maison.homelinux.net> a écrit:

> Hey 
> 
> I have a problem which seems to be related to shutdown for a Toshiba portege
> (it's seems that the problem is also on other Toshiba, on VAIO cw5, y
[...]
> If i shutdown the computer and wait some hours, the power consumption of the
> computer is not null, it's about the same as the power consumtion during a
> suspend of computer. In fact
> 
> Boot and halt with:
> Windows 7 ---> No power consumption after
> Linux 2.6.37-486-PAE --->  No power consumption after
> Linux >= 3.0  ---> Power consumption (about 45-50 mW if acpitool is correct)
[...]

Well can anybody just tell me the sequence of shutdown and power of a x86
computer in then linux kernell, or just how to verify that a device is power
off with a printk, or where to search or even only where is the part of code
doing this. There is many documentation about use device but nothing about
power off.

Thanks

François Boisson
