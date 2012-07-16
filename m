Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab2GPDJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 23:09:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63124 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab2GPDJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 23:09:46 -0400
MIME-Version: 1.0
From: Yang Bai <hamo.by@gmail.com>
Date: Mon, 16 Jul 2012 11:09:26 +0800
Message-ID: <CAO_0yfM_qmWd_dR7UH1Y6Rk6F5b9CTVduDKLmsLb8azrmL5NZA@mail.gmail.com>
Subject: How to map ata_link to physical link and ata_port to physical port
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hackers,

In our internal usage, we want to map the disk in system like
sd{a,b,c} to physical disk slot. When the disk is attached to LSI HBA
card, we find that we can rely on the phy attribute of the disk to
find the slot since this attribute does not change no matter which
kind of disks we attach or what order we attach the disks. But when
doing this for AHCI, we do not find an attribute that we can rely on
it to map the disk to slot. No matter ata_port number or ata_host
number, when we changed the order we attached the disks to slots, they
changed.

So I want to know is there some attribute we can get from AHCI that
map the logical disk to physical slot?

Thanks,
Yang
