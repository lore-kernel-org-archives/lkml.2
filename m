Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab2FZGe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 02:34:57 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:47033 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab2FZGe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 02:34:56 -0400
From: guanxuetao@mprc.pku.edu.cn
Message-ID: <50477.162.105.203.8.1340694078.squirrel@mprc.pku.edu.cn>
In-Reply-To: <20120626033225.16434.26282.stgit@amt.stowe>
References: <20120626033045.16434.17412.stgit@amt.stowe>
    <20120626033225.16434.26282.stgit@amt.stowe>
Date: Tue, 26 Jun 2012 15:01:18 +0800 (CST)
Subject: Re: [PATCH 13/16] unicore32/PCI: adjust section annotations for 
     'pcibios_setup()'
To: "Myron Stowe" <myron.stowe@redhat.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org, rth@twiddle.net,
        ink@jurassic.park.msu.ru, mattst88@gmail.com, linux@arm.linux.org.uk,
        starvik@axis.com, jesper.nilsson@axis.com, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        yasutake.koichi@jp.panasonic.com, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        chris@zankel.net, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8-4.0.1.el5
MIME-Version: 1.0
Content-Type: text/plain;charset=gb2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Make pcibios_setup() consistently use the "__init" section annotation.
>
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>

Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>


