Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1HaUpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 16:45:22 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:40223 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753375Ab1HaUpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 16:45:19 -0400
Date: Wed, 31 Aug 2011 13:45:15 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        iscsi-driver@qlogic.com
Subject: Re: linux-next: Tree for Aug 30 (scsi/qla4xxx)
Message-Id: <20110831134515.049f584b.rdunlap@xenotime.net>
In-Reply-To: <20110830171605.168f29decb0558fa31e59210@canb.auug.org.au>
References: <20110830171605.168f29decb0558fa31e59210@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 17:16:05 +1000 Stephen Rothwell wrote:

> Hi all,

[Sorry about the delay.. slow build machine.
Please ignore if this is already known/fixed.]


(on i386)

ERROR: "iscsi_boot_create_target" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_boot_create_ethernet" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_boot_create_host_kset" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_boot_create_initiator" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_boot_destroy_kset" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!

when CONFIG_ISCSI_BOOT_SYSFS is not enabled.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
