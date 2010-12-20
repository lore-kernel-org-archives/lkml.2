Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab0LTAaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 19:30:22 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36813 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab0LTAaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 19:30:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4D0EA38C.2090003@jp.fujitsu.com>
Date: Mon, 20 Dec 2010 09:30:04 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Jesse Barnes <jbarnes@virtuousgeek.org>
CC: LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [Resend][PATCH] PCI / Hotplug: Fix unexpected driver unregister
 in pciehp_acpi.c
References: <201012181329.46071.rjw@sisk.pl>
In-Reply-To: <201012181329.46071.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/18 21:29), Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki<rjw@sisk.pl>
> 
> If pcie_ports_disabled is set, pcie_port_service_register() returns
> error code and select_detection_mode() should not attempt to
> unregister dummy_driver and use dummy_slots.  It should return
> PCIEHP_DETECT_ACPI immediately instead.
> 
> Signed-off-by: Rafael J. Wysocki<rjw@sisk.pl>

Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Acked-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

