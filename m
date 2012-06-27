Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab2F0GGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 02:06:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60105 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2F0GGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 02:06:14 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FEAA2C0.5060804@jp.fujitsu.com>
Date: Wed, 27 Jun 2012 15:05:52 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <lenb@kernel.org>, <linux-acpi@vger.kernel.org>, <bhelgaas@google.com>,
        <shuahkhan@gmail.com>, <liuj97@gmail.com>, <andi@firstfloor.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 5/6] ACPI: Add _OST support for ACPI container hotplug
References: <1340743374-18535-1-git-send-email-toshi.kani@hp.com> <1340743374-18535-6-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1340743374-18535-6-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/06/27 5:42, Toshi Kani wrote:
> Changed container_notify_cb() to call ACPI _OST method when ACPI
> container hotplug operation has completed. Slightly restructured
> the code with the same logic except that the hot-add case will
> fail a request whenever device is set. This makes the error check
> to be more comprehensive.
> 
> The function sets eject_pending bit for an eject request since it
> does not initiate hot-remove operation. This bit is checked by the
> sysfs eject handler to determine if the request is originated from
> an ACPI eject notification.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Thank you for updating the change log.

Reviewed-by: <isimatu.yasuaki@jp.fujitsu.com>

