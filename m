Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab0GGWZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 18:25:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36663 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169Ab0GGWZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 18:25:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=VZOgOZhWmr53ZJPusZd2VTWjhJTDL7Fvcu5MBFo4/3vLIex8kBHByC32LTJcEMnXgH
         5XrZOIJIOdmXl2ZIE0iros0Kw3pPM8Jphw+9wkValahRx1BUoDQxkjZD2fu3G6PqukKm
         OwQcjvaoiVff2RMW2GIiyfFlTzywnbdAN551s=
MIME-Version: 1.0
Date: Wed, 7 Jul 2010 18:25:53 -0400
Message-ID: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com>
Subject: nic enumeration
From: Michael Di Domenico <mdidomenico4@gmail.com>
To: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an issue where I have an onboard NIC with effectively three
ports, no other NIC ports/chips are in the system

Nic0: xx:xx:xx:00:00:02
Nic1: xx:xx:xx:00:00:01
IPMI: xx:xx:xx:00:00:03

When I boot RedHat Linux, Nic1 becomes Eth0 and Nic0 becomes Eth1.

I understand there is a disconnect between BIOS and linux on which
device should get which Eth, as well as, what ensues when you have PCI
cards along side onboard ports.

What I'm curious about is how/why Linux actually decides Nic1 should be Eth0?

My theory is it starts on the lowest MAC address and works up,
depending partly on driver load order.

Given the above scenario, swapping the MAC addresses between Nic1 and
Nic0 would clear this issue.

Can anyone confirm or deny this?  Or explain/point me to, how it actually works.
