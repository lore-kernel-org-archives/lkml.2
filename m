Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab2K0MMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 07:12:14 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62935 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab2K0MMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:12:13 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-net@vger.kernel.org>
Subject: 3.6.8 - CONFIG_IXGBE_HWMON -- how to poll Intel 10GbE temperature?
Date: Tue, 27 Nov 2012 07:12:08 -0500
Message-ID: <008c01cdcc98$6cb48e80$461dab80$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac3MmFttNH5PTKLQS2aTqqtgifuW7A==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Which user-space application has support to read the temperature off of the
10GbE card?
Regular lm-sensors does not seem to be picking it up.

$ sensors|grep -e -
radeon-pci-0500
coretemp-isa-0000
nct6776-isa-0a30

Justin.

