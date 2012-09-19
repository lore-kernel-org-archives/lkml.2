Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab2ISB6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 21:58:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43906 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab2ISB6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 21:58:42 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5059256B.2010708@jp.fujitsu.com>
Date: Wed, 19 Sep 2012 10:52:43 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: konrad@kernel.org
CC: vgoyal@redhat.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com, hbabu@us.ibm.com,
        ishii.hironobu@jp.fujitsu.com, martin.wilck@ts.fujitsu.com
Subject: Re: [RFC][PATCH] Reset PCIe devices to address DMA problem on kdump
 with iommu
References: <501BB4EF.7080909@jp.fujitsu.com> <20120803114643.GA28330@redhat.com> <501F4877.5050605@jp.fujitsu.com> <20120806203902.GH25559@redhat.com> <50473306.1070803@jp.fujitsu.com> <20120910143604.GB639@redhat.com> <504F1343.7030607@jp.fujitsu.com> <20120914200334.GA9041@phenom.dumpdata.com>
In-Reply-To: <20120914200334.GA9041@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/09/15 5:03), Konrad Rzeszutek Wilk wrote:
>> As to the boot parameter to enable this function, you suggested using
>> reset_devices. I found that on a certain platform resetting devices
>> caused PCIe error due to a hardware bug. Therefore I think we need
>> new parameter apart from reset_devices to disable this function on
>> such a machine.
>
> Wouldn't a DMI quirk be better for this? That way the second kernel
> internally would know not to do this.

That sounds good. I'll try it, thanks.

Thanks,
Takao Indoh

