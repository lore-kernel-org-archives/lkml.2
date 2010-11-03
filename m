Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab0KCNRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 09:17:04 -0400
Received: from lechat.rtp-net.org ([88.191.19.38]:36783 "EHLO
	lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab0KCNRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 09:17:00 -0400
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: sowani@gmail.com
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 2.6.36 1/1] xgifb: change obsolete pci_find_device() with pci_get_device().
Organization: RtpNet
References: <4CD15F60.8090305@gmail.com>
Date: Wed, 03 Nov 2010 14:18:09 +0100
In-Reply-To: <4CD15F60.8090305@gmail.com> (Atul Sowani's message of "Wed, 03
	Nov 2010 18:40:56 +0530")
Message-ID: <87r5f25ywe.fsf@lechat.rtp-net.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atul Sowani <sowani@gmail.com> writes:

> Replaced obsolete pci_find_device() calls with pci_get_device() calls. This is
> recommended in pci.txt filei in PCI Documentation.
>
> Signed-off-by: Atul Sowani <sowani@gmail.com>

Acked-by: Arnaud Patard <arnaud.patard@rtp-net.org>
