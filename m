Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2GIKIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:08:45 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:48863 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2GIKIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:08:43 -0400
Message-ID: <4FFAACF8.8040801@huawei.com>
Date: Mon, 9 Jul 2012 18:05:44 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
CC: Don Dutile <ddutile@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [Resend with Ack][PATCH v1] PCI: allow acpiphp to handle PCIe
 ports without native PCIe hotplug capability
References: <1338795894-6292-1-git-send-email-jiang.liu@huawei.com> <CAErSpo7NiCsuM+UxveZbYxNsCiStMH5SLZ8EdFzJ7EduB306OQ@mail.gmail.com> <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com> <4FF34CEF.3090400@redhat.com> <CAErSpo7=BzPX87qgKS_xkJg4o8BGDan-o7D9NqRiqKvH0kLjfQ@mail.gmail.com>
In-Reply-To: <CAErSpo7=BzPX87qgKS_xkJg4o8BGDan-o7D9NqRiqKvH0kLjfQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn and Yinghai,
	What's the policy to export a symbol by EXPORT_SYMBOL()
or EXPORT_SYMBOL_GPL()? I know the legal difference, but don't
know when I should mark a symbol as GPL.
	Thanks!


