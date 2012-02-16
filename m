Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab2BPPEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:04:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab2BPPEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:04:21 -0500
Date: Thu, 16 Feb 2012 17:04:22 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org
Subject: shpc with acpi=off?
Message-ID: <20120216150421.GA26167@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a box where shpc works fine with acpi,
as well as when acpi is not built into kernel,
but fails with acpi=off
Some debugging seems to indicate that
acpi_get_hp_hw_control_from_firmware
fails with acpi=off.

Is this a bug or is there a reason to prevent shpc
from working in this setup?
Do we even care about acpi=off?
Assuming we want to make acpi_get_hp_hw_control_from_firmware
succeed with acpi=off, what is the best way to do this?
Check acpi_pci_disabled?

Thoughts?
-- 
MST
