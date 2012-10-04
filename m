Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964910Ab2JDOOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 10:14:46 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:41797 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964793Ab2JDOOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 10:14:45 -0400
MIME-Version: 1.0
Date: Thu, 4 Oct 2012 10:14:43 -0400
Message-ID: <CAHFgRy975B0fPsBqRY7xW53egRpUxcLG=6DYQGawz+M4hTxWdg@mail.gmail.com>
Subject: 3.6.0+ (GIT) -- lpc_ich: Resource conflict(s) found affecting gpio_ich
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI Warning: 0x0000000000000828-0x000000000000082f SystemIO conflicts
with Region \PMIO 1 (20120711/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use
it instead of the native driver
ACPI Warning: 0x0000000000000500-0x000000000000053f SystemIO conflicts
with Region \GPIO 1 (20120711/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use
it instead of the native driver
lpc_ich: Resource conflict(s) found affecting gpio_ich
