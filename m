Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab2HBVrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 17:47:17 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64934 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab2HBVrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 17:47:15 -0400
MIME-Version: 1.0
In-Reply-To: <1343836477-7287-27-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com> <1343836477-7287-27-git-send-email-jiang.liu@huawei.com>
From: Roland Dreier <roland@kernel.org>
Date: Thu, 2 Aug 2012 14:46:54 -0700
X-Google-Sender-Auth: 76vAif6B2fRGEg9u5ZPejVrkUWk
Message-ID: <CAG4TOxMzOeW4PE+sZmvu7OeO15RYQbn81s=nN3mQqSMPD8JMbg@mail.gmail.com>
Subject: Re: [PATCH v3 26/32] PCI/mthca: use PCIe capabilities access
 functions to simplify implementation
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use PCIe capabilities access functions to simplify mthca driver's
> implementation.

Acked-by: Roland Dreier <roland@purestorage.com>
