Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2HCSF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 14:05:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37572 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2HCSF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 14:05:26 -0400
Message-ID: <501C12E2.3060807@wwwdotorg.org>
Date: Fri, 03 Aug 2012 12:05:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 12/32] PCI/ARM: use PCIe capabilities access functions
 to simplify implementation
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com> <1343836477-7287-13-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1343836477-7287-13-git-send-email-jiang.liu@huawei.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 09:54 AM, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Use PCIe capabilities access functions to simplify PCIe ARM implementation.
> 
> Signed-off-by: Jiang Liu <liuj97@gmail.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
