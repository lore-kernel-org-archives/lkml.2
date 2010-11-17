Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab0KQVAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:00:41 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:52738 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754022Ab0KQVAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:00:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pUA2/6w7rATjUhHqRxd3TZn9VT4E8NySOr5rPUWXAtNpAOM76L95usjF5KC4rch2+dybt0lbos85kkShRRRiYuoc7FL8PU0mcw2ntO4O3ugy5uog0T2XB7ISm4EPqWh9;
Date: Wed, 17 Nov 2010 13:00:18 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: maciej.rutecki@gmail.com
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, martin.wilck@ts.fujitsu.com
Subject: Re: [Regression] [2.6.37-rc2] WARNING: at
 drivers/pci/pci-sysfs.c:758 pci_mmap_resource+0x133/0x190()
Message-ID: <20101117130018.432b0ec8@jbarnes-desktop>
In-Reply-To: <201011172153.11313.maciej.rutecki@gmail.com>
References: <201011172153.11313.maciej.rutecki@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 21:53:10 +0100
Maciej Rutecki <maciej.rutecki@gmail.com> wrote:

> Last known good: 2.6.37-rc1
> Bad kernel: 2.6.37-rc2
> Hardware: VirtualBox

Should be fixed in master now, please re-test.

-- 
Jesse Barnes, Intel Open Source Technology Center
