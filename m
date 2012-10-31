Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab2JaFt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:49:26 -0400
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:36682 "HELO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752965Ab2JaFtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:49:23 -0400
From: Ritesh Majumdar <r.majumdar@globallogic.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac23K3fJ97PcRt1ySZeBbs4J2M+GNQ==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Date: Wed, 31 Oct 2012 11:19:18 +0530
Message-ID: <55629fbb6de9caab984bcefb1adfce25@mail.gmail.com>
Subject: Incomplete vmcore file
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am using kernel version 2.6.34.4 and trying to enable kernel crash using
kexec (kdump). Every time the crash occurs, the size of the dump file
(vmcore) is incomplete (around 20 MB).OS is installed with 8 GB of RAM.
Due to this gdb/crash fails to analyze the core dump.

Does anyone know where to look for this issue? Is there any known issue
with this kernel version or any fix available?

Regards,
Ritesh.
