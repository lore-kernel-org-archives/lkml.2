Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249Ab2JXQEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:04:43 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:36859
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757869Ab2JXQEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:04:41 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Subject: Drivers: scsi 
Date: Wed, 24 Oct 2012 09:25:38 -0700
Message-Id: <1351095938-12204-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the low level driver returns SCSI_MLQUEUE_DEVICE_BUSY,
how is the command retried; I suspect the retry is done after some delay.
Is this delay programmable? If the device state changes,
can the low level driver notify upper layers that it can now handle
the command that it had failed earlier with SCSI_MLQUEUE_DEVICE_BUSY.

Regards,

K. Y
