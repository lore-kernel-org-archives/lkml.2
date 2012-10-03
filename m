Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab2JCBCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 21:02:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41111 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2JCBCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 21:02:37 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <506B8D7B.8090004@jp.fujitsu.com>
Date: Wed, 03 Oct 2012 09:57:31 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: andi@firstfloor.org
CC: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        martin.wilck@ts.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, vgoyal@redhat.com,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de
Subject: Re: [PATCH v2 0/2] Reset PCIe devices to address DMA problem on kdump
 with iommu
References: <20121002074434.204.47750.sendpatchset@indoh> <m2mx04wtpz.fsf@firstfloor.org>
In-Reply-To: <m2mx04wtpz.fsf@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/03 4:37), Andi Kleen wrote:
> Takao Indoh <indou.takao@jp.fujitsu.com> writes:
>
>> These patches reset PCIe devices at boot time to address DMA problem on
>> kdump with iommu. When "reset_devices" is specified, a hot reset is
>> triggered on each PCIe root port and downstream port to reset its
>> downstream endpoint.
>
> Great. I've been pondering this for a long time, but you did finally
> implement it. I hope this will make kdump a lot more reliable at least
> on the systems that support per port reset.

Actually I got the idea of this patch from your comment below;-)
http://permalink.gmane.org/gmane.linux.network/162414

>
> Now the only question is: why make it a option and not default?

Except kdump I don't know the situation where this reset is useful, so I
introduced it as option so that it works only during kdump.

Thanks,
Takao Indoh

