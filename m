Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab2FRECx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 00:02:53 -0400
Received: from nm24.bullet.mail.sp2.yahoo.com ([98.139.91.94]:20765 "HELO
	nm24.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750763Ab2FRECv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 00:02:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 33427.73761.bm@omp1060.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=XFlh4OJXnjm1xFwsmT1lwuiEDHIwfAwINAcMvOdrFlh52wCKjfKl3aNNuIj8AXNeZFcf/uHm937dF6VdbDkwi0TfUWIiO74Mnq4xG2Q0zLr6+Ho57+OQzzQ+jhdhEnZoE4M6Hhnrn41hV/oG+PR4U1dJeB+DiCuJ6pswxMx+uR8=;
X-YMail-OSG: 3k.rtygVM1n2r0tDuMKYfnKY9bFzyyxrtWpjn.GMY7ICfiM
 C1uACmnPMmofgSI1H8JZbPo5PS8EkZfCmrhlC.BpRgiOLCz9btxl8tKbkLVf
 QtWsqSFsFDktJDR.YMtHayoFgoAm5CKck52xY37vsk4wlLNDqMoT2wIEKHFu
 kM3uwcLsDgCIok3DcM_ZCFDitrLW8X9fQj99bbfc_ynC1qkr0DESB6fnZ1Oi
 5JAYgN7TsDgPOHx95yKgM2psdEGBM5uORJzPh.Dsqkj.mGobAsqah3IBeKUg
 V8uOE4u9vTJ3aUaSiNI1JpThzyYGRM7Gke3eoiHwgrPkBoOJW.aCTRzu4WAA
 iEO7DPIx7WckM.np7_NOsx5Tw6VxJHxPk2e8vZSUkskI.abw3nAfSptv9rBf
 irAY3ZEVi.Ii9TUOrhEcwIF1bb.biSNy56O6z_h7kr8oRBleplt7Ic_UcHw4
 ZqPD.uloKPBwRpwVi61UyPCII532MMwYd.96YDfd4uhzMy6TxKPhWw69kVfO
 .SSwPch7R4gooWPTxSWzSYAJ_.PMEDZaw3di3SRFRI9XKN.oj2AxfAJEMV0u
 .DVO9cQB6AqgqAjuTZr.FpjsIbXXX84.B7w--
X-Mailer: YahooMailClassic/15.0.6 YahooMailWebService/0.8.118.349524
Message-ID: <1339992170.35835.YahooMailClassic@web113213.mail.gq1.yahoo.com>
Date: Sun, 17 Jun 2012 21:02:50 -0700 (PDT)
From: John <jhnlmn@yahoo.com>
Subject: What is the status of fanotify bugs?
To: linux-kernel@vger.kernel.org
Cc: eparis@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I googled and found at least 2 fanotify bugs,
which were discussed and patches were submitted but never merged into the kernel:

1. This one is more than 2 years old. Seems to be an obvious bug:
http://groups.google.com/group/linux.kernel/browse_thread/thread/46b25f4dfc96d811

2. This discussion was abruptly terminated last year:
http://groups.google.com/group/linux.kernel/browse_thread/thread/5e21ff2b0c446b69

And I have another problem, which is a complete show stopper for me:
fsnotify/fanotify do not pass file/directory  creation/deletion events
when working in FAN_MARK_MOUNT mode.
I was hoping to get notified about file system changes, but it appears to be impossible.
A directory with many subdirectories can be deleted and fsnotify/fanotify completely ignore this event.

So, I wonder whether fsnotify/fanotify framework is still being maintained and used by anybody.
If nobody else cares about it, then I will need to make my own file system notification hook.
But, of course, it would be better to fix fsnotify/fanotify so that I can avoid maintaining my own notification code.

What do you think?

Thank you
John


