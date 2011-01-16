Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab1APTcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 14:32:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39819 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab1APTcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 14:32:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: build error at include/linux/pci-acpi.h:39
Date: Sun, 16 Jan 2011 20:32:21 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>
References: <AANLkTin+OMfm2Z6idFck9gcP+bmH6pJNso7iMiUvYtJ5@mail.gmail.com>
In-Reply-To: <AANLkTin+OMfm2Z6idFck9gcP+bmH6pJNso7iMiUvYtJ5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101162032.21419.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 16, 2011, Alexander Beregalov wrote:
> Hi
> 
> kernel is v2.6.37-7733-g1b59be2
> 
> In file included from drivers/pci/pcie/aer/aerdrv.c:21:
> include/linux/pci-acpi.h:39: error: expected '=', ',', ';', 'asm' or
> '__attribute__' before 'acpi_find_root_bridge_handle'
> 
> CONFIG_ACPI is not set

A patch for that has been sent already:
https://patchwork.kernel.org/patch/481501/

Thanks,
Rafael
