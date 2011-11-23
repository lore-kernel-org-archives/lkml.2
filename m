Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab1KWXpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 18:45:01 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50718 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1KWXpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 18:45:00 -0500
MIME-Version: 1.0
Date: Thu, 24 Nov 2011 00:44:59 +0100
Message-ID: <CAGPN=9Q1HMVO27jr0e8az4SV9TyC_JL48mKWZHi8kHRfhQddMQ@mail.gmail.com>
Subject: EHCI powersave causes shutdown to freeze
From: Patrik Kullman <patrik.kullman@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After creating a powersave script based on PowerTOP Tunables, this
particular line prevented the system from being able to shutdown (Asus
Zenbook UX31E, kernels 3.0 - 3.1.2):

### Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced
Host Controller #1
echo auto > /sys/bus/pci/devices/0000:00:1d.0/power/control


Kernel prints the "Power Down." message but machine doesn't power down.

Is this a known bug?
Could this be fixed in the driver instead of:

echo on > /sys/bus/pci/devices/0000:00:1d.0/power/control

on system shutdown?
