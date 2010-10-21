Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab0JUPs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:48:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35680 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab0JUPsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:48:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=uzUNjqpieFL+nEfH7/yH8FX0dfOxDUD8Ooq/lEz0G5wByUo76nGRQo/lWr0KaMmsfs
         zQR6JGNOC6YvZo10CVqlrsucY7zQzONOsiSQS7o6irMlgMyA6qc2hA9BQd9OWXYi1aTu
         EftHfGk+u1Er1w9saNZDbMSXWlxtaq2RcVzqQ=
MIME-Version: 1.0
Date: Thu, 21 Oct 2010 13:44:12 -0200
Message-ID: <AANLkTikYZh2fG1+dkCC0dmOKbnA1GrmcxnwsvW6NdNcR@mail.gmail.com>
Subject: 2.6.34.1 hangup with partial log file
From: Robert Pipca <robertpipca@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using a xfs filesystem on a sata-2 controller with 2.6.34.1 as a
webcache machine on a 30Mbps ISP.

The machine frooze and sysadmin took a picture and restarted the
machine. Syslog didn't record anything.

The photo had these:

[<ffffffff811c74d2>] blk_peek_request+0x162/0x176
[<ffffffff8126e473>] ? scsi_dispatch_cmd+0x170/0x1a5
 can't see this line....only end with "_fn+0x79/0x430
[<ffffffff811c7b6d>] __blk_run_queue+7d/0x13f
[<ffffffff811c7cda>] blk_run_queue+0x21/0x35
[<ffffffff81272bdc>] scsi_run_queue+0x2d7/0x36e
[<ffffffff81262867>] ? put_device+0x12/0x14
[<ffffffff81273753>] scsi_next_command+0x36/0x47
[<ffffffff811273fee>] scsi_io_completion+0x1d0/0x42b
[<ffffffff8102a12e>] ? enqueue_entity+0x129/0x131
[<ffffffff8126e2e8>] scsi_finish_command+0xb0/0xb9
[<ffffffff81274355>] scsi_softirq_done+0xfc/0x105
[<ffffffff811cbf6f>] blk_done_softirq+0x67/0x77
[<ffffffff8103aa80>] __do_softirq+0x91/0x199
[<ffffffff81019261>] ? ack_apic_level+0x79/0x1cf
[<ffffffff810037cc>] call_softirq+0x1c/0x28
[<ffffffff81005473>] do_softirq+0x33/0x68
[<ffffffff8103a7ac>] irq_exit+0x36/0x78
[<ffffffff81004b57>] do_IRQ+0xa7/0xbe

Is this useful at all?

I could send you my .config if that helps...or the kernel image itself.

Please let me know what can I provide to find out what happened and
how to fix it. This is a production machine and the ISP was on a
bridge through this webcache...so the whole ISP went down.

Please help!

- Robert
