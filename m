Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab1ARVqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:46:51 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:45831 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1ARVqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:46:49 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 1/1 Version 2.0] PCI: allocate essential resources before reserving hotplug resources
Date: Tue, 18 Jan 2011 14:46:02 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-26-generic; KDE/4.4.2; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, clemens@ladisch.de,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        peter.henriksson@gmail.com, ebiederm@aristanetworks.com
References: <201010081416.57454.bjorn.helgaas@hp.com> <20110114181915.GA7476@ram-laptop> <20110118213009.GA9281@ram-laptop>
In-Reply-To: <20110118213009.GA9281@ram-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101181446.04412.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 18, 2011 02:30:09 pm Ram Pai wrote:
>         PCI: pre-allocate additional resources to devices
>         only after successful allocation of essential resources.
> ...

When you post a new version, can you please include some text about
"what changed between v1 and v2"?
