Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab1JYPwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 11:52:41 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52088 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab1JYPwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 11:52:39 -0400
MIME-Version: 1.0
In-Reply-To: <4EA6ACBA.20200@jp.fujitsu.com>
References: <4E9A3092.4080309@oracle.com>
	<4E9A3408.9080905@oracle.com>
	<CAErSpo5XdM+1OFmoU+rN_QNWCJ0Wzv1VwKxsTo9hTq=2=7KEHA@mail.gmail.com>
	<4E9C6F0E.40501@oracle.com>
	<CAErSpo7ofdVixyGR74_mc6ND5C3LROiR9PVzwNZaDe23ptJ2=Q@mail.gmail.com>
	<4E9CAB21.2020302@oracle.com>
	<CAErSpo4PLDfapndXJp-sXS-SJtv0a7PaD=UKX0HV0OV34an3kQ@mail.gmail.com>
	<4E9DB11A.7030505@oracle.com>
	<4EA6ACBA.20200@jp.fujitsu.com>
Date: Tue, 25 Oct 2011 08:52:38 -0700
X-Google-Sender-Auth: d1S48jylaXQy4pSUiQmrn5dEUss
Message-ID: <CAE9FiQXOU+7F0N8G_d=W_HWocvwLum9qL6oZOVGfRLSp=UXs8Q@mail.gmail.com>
Subject: Re: [PATCH 1/8] pci: Make sriov work with hotplug removal
From: Yinghai Lu <yinghai@kernel.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/25 Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>
> I have one question.
>
> I think pci_stop_bus_devices() is called only when bridge device is removed.
> Are you trying to hot-remove the bridge device that has SR-IOV capable
> devices on the subordinate bus?

Yes, I should include more pci info in patch comments:

root complex: 80:02.2
pci express modules: have pcie switch and are listed as b0:00.0,
b1:02.0 and b1:03.0.
                 end devices  are b2:00.0 and b3.00.0.
                 VFs are: b2:00.1,... b2:00.3, and b3:00.1,...,b3:00.3

Thanks

Yinghai Lu
