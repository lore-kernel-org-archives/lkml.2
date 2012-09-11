Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461Ab2IKOpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:45:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759170Ab2IKOpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:45:35 -0400
Date: Tue, 11 Sep 2012 10:43:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com, hbabu@us.ibm.com,
        ishii.hironobu@jp.fujitsu.com, martin.wilck@ts.fujitsu.com
Subject: Re: [RFC][PATCH] Reset PCIe devices to address DMA problem on kdump
 with iommu
Message-ID: <20120911144323.GF12039@redhat.com>
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

On Tue, Sep 11, 2012 at 07:32:35PM +0900, Takao Indoh wrote:

[..]
> I'll post new patch which clears bus master bit and resets devices in
> second kernel.
> 
> As to the boot parameter to enable this function, you suggested using
> reset_devices. I found that on a certain platform resetting devices
> caused PCIe error due to a hardware bug. Therefore I think we need
> new parameter apart from reset_devices to disable this function on
> such a machine.

Can you explain a bit more how the error happens. I still don't think
that because of a bug in a platform somewhere we should be introducing
a separate command line parameter and not reuse the exisiting one. Also
you have not explained what's the bug and how a new parameter will 
avoid the bug.

Thanks
Vivek
