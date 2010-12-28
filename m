Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab0L1POU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 10:14:20 -0500
Received: from postman.sesda2.com ([63.68.157.115]:49790 "HELO sesda2.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750972Ab0L1POS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 10:14:18 -0500
X-Greylist: delayed 1895 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Dec 2010 10:14:08 EST
Message-ID: <58915.128.183.168.54.1293547325.squirrel@mail.sesda2.com>
Date: Tue, 28 Dec 2010 09:42:05 -0500 (EST)
Subject: server load extremely high
From: "Michael Alaimo" <malaimo@sesda2.com>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8-5.el4.centos.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Priority: 3 (Normal)
Importance: Normal
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a server that is getting loads of 300+.  The cpu is idle and memory
is not being fully utilized.  At least that is what htop reports.  The
system subsequently crashes.

I believe the issue started when we attached the "LSI Logic / Symbios
Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07)" controller.

There are no messages in the system logs related to this at all.

Has anyone ever seen this problem before?

Mike
