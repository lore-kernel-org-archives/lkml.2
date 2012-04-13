Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab2DMIEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:04:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34184 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab2DMIEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:04:44 -0400
Date: Fri, 13 Apr 2012 16:11:05 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [RFC] enable FUA support in libata
Message-ID: <20120413081104.GA4953@gmail.com>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff and list,

Recently I met a problem about FUA support of SATA disk.  In my machine,
it has a SATA disk that supports FUA feature.  But after system starts
up, it displays that the disk cannot support FUA from dmesg.

I notice this commit (c3c013a2).  It disables FUA support in all of SATA
disk.  But the commit log is too simple to know why we should disable
FUA support in libata.  Could you please explain it?  Thank you.

Regards,
Zheng
