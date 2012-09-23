Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab2IWEZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 00:25:46 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52067 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2IWEZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 00:25:43 -0400
Message-ID: <505E8F44.9020208@kernel.org>
Date: Sun, 23 Sep 2012 00:25:40 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: hpa@zytor.com, initramfs@vger.kernel.org, robert.moore@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        yinghai@kernel.org, eric.piel@tremplin-utc.net, vojcek@tlen.pl
Subject: Re: [PATCH 2/2] ACPI: Override arbitrary ACPI tables via initrd for
 debugging
References: <1348234085-39220-1-git-send-email-trenn@suse.de> <1348234085-39220-3-git-send-email-trenn@suse.de> <505DD65F.9080203@kernel.org> <201209230317.04050.trenn@suse.de>
In-Reply-To: <201209230317.04050.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config ACPI_INITRD_TABLE_OVERRIDE
> +       bool
> +       default y

Do distros in addition to SuSE concur they want to ship this way?

The last time we tried to make debugging easier we added
ACPI_CUSTOM_METHOD, which allowed root to over-ride an AML method
on a running system.  Distro security-minded people were not amused.

thanks,
-Len Brown, Intel Open Source Technology Center

ps I noticed your reference to acpidump in the README.
That reminded me to push it to the kernel source tree.
Its new home will be tools/power/acpi/

