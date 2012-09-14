Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab2INUOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 16:14:23 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61540 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab2INUOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 16:14:21 -0400
Date: Fri, 14 Sep 2012 16:03:36 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: vgoyal@redhat.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com, hbabu@us.ibm.com,
        ishii.hironobu@jp.fujitsu.com, martin.wilck@ts.fujitsu.com
Subject: Re: [RFC][PATCH] Reset PCIe devices to address DMA problem on kdump
 with iommu
Message-ID: <20120914200334.GA9041@phenom.dumpdata.com>
References: <501BB4EF.7080909@jp.fujitsu.com>
 <20120803114643.GA28330@redhat.com>
 <501F4877.5050605@jp.fujitsu.com>
 <20120806203902.GH25559@redhat.com>
 <50473306.1070803@jp.fujitsu.com>
 <20120910143604.GB639@redhat.com>
 <504F1343.7030607@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504F1343.7030607@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As to the boot parameter to enable this function, you suggested using
> reset_devices. I found that on a certain platform resetting devices
> caused PCIe error due to a hardware bug. Therefore I think we need
> new parameter apart from reset_devices to disable this function on
> such a machine.

Wouldn't a DMI quirk be better for this? That way the second kernel
internally would know not to do this.
