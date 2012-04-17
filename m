Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2DQCIC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 22:08:02 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36582 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2DQCH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 22:07:58 -0400
MIME-Version: 1.0
In-Reply-To: <201204161907.13806.rjw@sisk.pl>
References: <4F8790F6.5080408@intel.com>
	<201204132141.58063.rjw@sisk.pl>
	<4F8B828E.9060606@intel.com>
	<201204161907.13806.rjw@sisk.pl>
Date: Tue, 17 Apr 2012 10:07:56 +0800
Message-ID: <CAC=cRTNdLu=A64YAEp78ENc1h2OJKusXY3Wm9LuY4drz9pbomg@mail.gmail.com>
Subject: Re: [RFC PATCH] PCIe: Add PCIe runtime D3cold support
From: huang ying <huang.ying.caritas@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 1:07 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Moreover, I really don't think it's a good idea to put PCI Express ports into
> low-power states in general.  It might work on your platform, whatever it is,
> but that doesn't mean it's going to work on every PCI Express system out
> there.  I actually know of a number of such systems where it surely won't
> work at all.

The runtime PM support for PCIe port is not turned on by default, we need

# echo auto > /sys/devices/pcixxxx:xx/<pci id>/power/control

to turn on it.  And we will turn on it on system it works.  Is this sufficient?

Best Regards,
Huang Ying
