Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab2CMUcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 16:32:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43118 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814Ab2CMUcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 16:32:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pintu.k@samsung.com
Subject: Re: [INFO] : Hibernation and Resume between 2 similar devices
Date: Tue, 13 Mar 2012 21:36:56 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <28119509.96581331614425960.JavaMail.weblogic@epml27>
In-Reply-To: <28119509.96581331614425960.JavaMail.weblogic@epml27>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201203132136.56353.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 13, 2012, PINTU KUMAR wrote:
> Dear All,
> 
> I am just curious to know if it is possible to "Hibernate in one device" and "Resume the hibernated image from another similar device".

Not out of the box (you'd need to hack the kernel for that to work I think,
at least on x86) and the devices would need to be _exactly_ identical.
Moreover, if there is read-write mass storage in them, the filesystems on
both would have to be exactly identical as well (including metadata and data
layout etc.).

> Suppose, I have 2 exactly similar device (Laptop or mobile phone) with me.
> At one time I will be working on only one device at a time.
> Suppose I started my work on "Device 1"  with few opened application and later I wanted to switch to "Device 2" which is exactly similar to Device 1.
> I thought to hibernate (suspend to disk) the Device 1 and store the hibernated image as a swap file and later transfer to sd card.
> Then take of the sd card from Device 1 and put it into Device 2.
> Copy the swap file from sd card to Device 2 in some swap partition.
> Then reboot the Device 2 to Resume from this swap file.
> I will get back my Device 1 content in Device 2.
> 
> Hope this is possible ?

It may be possible to make it kind of work, but I wouldn't recommend it to
anyone.

Thanks,
Rafael
