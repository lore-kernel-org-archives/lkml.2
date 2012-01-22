Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab2AVRiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 12:38:46 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46368 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2AVRip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 12:38:45 -0500
MIME-Version: 1.0
From: Andrey Moshbear <andrey.vul@gmail.com>
Date: Sun, 22 Jan 2012 12:38:22 -0500
Message-ID: <CAFnZeoTQTF5UYkK7nuan8UVZG7sqGGK84z-x=wLHoVn2R1N5fw@mail.gmail.com>
Subject: 
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my current config, #modprobe nvidia fails with ENODEV.
dmesg reveals that it (nvidia.ko) can't find an IRQ, thus causing
probing and device initialization to fail.

What is my .config missing (or has erroneously enabled)?

Kernel is 3.1.6. -pf patchset is irrelevant here because the error is
in neither scheduler nor ACPI hibernation code (i.e. it's stock where
it counts).

/usr/src/linux/.config: http://pastebin.com/9KXQpMdt

lspci -vv: http://pastebin.com/gfUF1N18
