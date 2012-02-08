Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab2BHWLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 17:11:25 -0500
Received: from nm13.bullet.mail.ird.yahoo.com ([77.238.189.66]:45474 "HELO
	nm13.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755866Ab2BHWLY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 17:11:24 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 723081.91647.bm@omp1015.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=pOeZXfxYgqd7vfb2AkXWUT5fasPy06eCFEbpfijaSv/ArdVIbYBCJ42RdlDCPpBNhC5EvBej8hzpmg2MTDZwJCHSTN/rGcg7QePknLf4Gte7tqKGLs4obv9tTHMTA40tTNqY9K7wtPHMzzq6LR5KooZP8N1hcJ2tSDbvVQ1upy8=;
X-YMail-OSG: e.yHbrcVM1mt2N_MYF5VmM8ndN6RTCUKAzY5kXGfPtBMQai
 wYOQc_rKfDvEK48nLhkPNGJCXfWjImG0UJJxGUZJqVwk.7UormKzYYlrkbm5
 4eqGimTwvfpiY8SnNI44RpsYGbATzvuiGPoP8.bwkPIIRsyiPS66JD.Z92wK
 XPTLHQ3VuS_LEnVBR1hjmhyjw3QZXffTUWnS7ZHDkf4RHIyC4Bi60vvZKXA2
 fa8hmOiyUiuE.rcKfscI2MXreroGNekM_Tc3PcgvmVQ_Cv5eUMhgH81rcR2b
 eMEmW8NiuVKbpet1RJwlqjM.MEksdgRoD9UAkvvoNsp6CUIyjq398ceGirWo
 sj.YlWFHR5PnpueDz3ZiN6VCQvf.0BUXvUDW_2nJiWt0MbDWaT_h1EVlUzsD
 .0styROg68lGRYiciwFNWHjhyQqye1LGab_x9MNN83nT4maXAdVe4pftr_5J
 4VMvfnAdVra80QcvHaHNBKVR1auAiNP0szSq.1szbAKrA9pi9qn9qEaiAtXj
 lVYriCOPHC0zrNvDrrDk4pp_R9_6hQXy9_9Q6wO7QOWfusgvAbD5R7BwfLQ-
 -
X-Mailer: YahooMailWebService/0.8.116.338427
Message-ID: <1328739082.22121.YahooMailNeo@web171408.mail.ir2.yahoo.com>
Date: Wed, 8 Feb 2012 22:11:22 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Reply-To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: [announce] Gujin GPL bootloader version 2.8.5
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a new version v2.8.5 of the GPL Gujin boot/linux loader at http://gujin.org (i.e. sourceforge)
with bug fixes and improvements, and Debian/Ubuntu/Fedora packages in 32 and 64 bits for easy
installation on i386/amd64 PC.

This version contains quite a lot of bug fixes, changelog is:
- Fix (error loading file 0x3401) loading kernel on highly fragmented ext2 partitions
- Fix a bug when /boot/gujin.ebios created not contiguous
 (hdparm --fibmap /boot/gujin.ebios), and enable uninstalling those not contigous
 files (happens on highly fragmented 1024 bytes/block ext2 partitions)
- Fix a problem when MBR has 0x29 signature but invalid bytes/sectors
- Fix a bug where /boot directories were not probed on FAT (directory entries contains
 null size on FAT)
- Behaves better when partitions do not have a label, use PBR label or Gujin "part n"
- no more compile with "-funsigned-char", fix bugs about mixed sector sizes in iso images
(loading kernel on 512 bytes/sector FAT filesystem written on a CDROM/DVDRAM)
- add "relro" linker
flags for the installer
- Re-enable PCI I/O space of PCI IDEs if disabled by BIOS (when BIOS finds no disk)
- fix possible problem with BIOS disk nb_heads=256
- add docs for changing Linux parameter by Shift-Fn or Shift-mouse, and
 Control-Break behaviour
- add probing for /sys/block/sr[0-9] for "gujin --report-signature"
- update to support PCI BIOS v3.0+ which is not fully backward compatible,
 and use VirtualBox bug.
- Fix to handle older HP BIOS bugs
- update GPG signature, add new encryption/signature subkeys

Downloads at: http://sourceforge.net/projects/gujin/files/

Have fun,
Etienne. 
