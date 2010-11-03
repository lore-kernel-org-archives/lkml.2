Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0KCL1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 07:27:43 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:56051 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab0KCL1l convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:2:1>);
	Wed, 3 Nov 2010 07:27:41 -0400
Message-Id: <4CD15538020000780002060B@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 03 Nov 2010 11:27:36 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <jbarnes@virtuousgeek.org>
Subject: your patch "x86/PCI: host mmconfig detect clean up"
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch (commit 068258bc15439c11a966e873f931cc8e513dca61)
you made the call to pci_mmcfg_reject_broken() unconditional. This
breaks pci=check_enable_amd_mmconf when the mmconfig space
wasn't enabled by the BIOS, since obviously the BIOS can't reserve
in the E820 map the range Linux is going to assign. As the commit
message doesn't really tell the reason for you doing so, could you
shed some light on this, so a proper change to restore the original
functionality can be put together?

Thanks, Jan

