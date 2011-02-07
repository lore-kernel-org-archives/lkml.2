Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1BGWXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 17:23:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51711 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab1BGWXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 17:23:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 0/6] ACPI / PM: Simplifications of core suspend and hibernate code
Date: Mon, 7 Feb 2011 23:16:41 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102072316.41270.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series of patches reduces complexity of the core suspend
and hibernate code a bit.

[1/6] - Remove acpi_restore_state_mem() which isn't used.
[2/6] - Do not turn interrupts on/off in acpi_suspend_enter().
[3/6] - Move the "back to C" message and make it meaningful.
[4/6] - Move the call to acpi_save_state_mem() towards do_suspend_lowlevel().
[5/6] - Merge do_suspend_lowlevel() into acpi_save_state_mem().
[6/6] - Do not turn interrupts on/off in acpi_hibernation_enter().

I'm regarding these patches as 2.6.39 material, if there are no objections.

Thanks,
Rafael
