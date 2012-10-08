Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab2JHFg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 01:36:57 -0400
Received: from nm1-vm3.bullet.mail.gq1.yahoo.com ([98.136.218.82]:40002 "HELO
	nm1-vm3.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751751Ab2JHFgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 01:36:53 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Oct 2012 01:36:53 EDT
X-Yahoo-Newman-Id: 756883.87645.bm@smtp203.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: bfs4KMYVM1kSCLsgpoOJKG8nbFR34uO58FdfFLMpqdG5TI6
 8hys9CeiO0VbS0h0VfIgaMB1UyDBfBNrt.QsBm5bnaB7njpljO2h8T4ryeeh
 KqxXuxYqusnG.H_4K0j9cR32lXrW2f5cxKw3Xb0nOczXQD8VjL5Zu8SUS_7U
 9f_Jary189AHazy5kCW0YCIN1bROpy4tWIcsM7bswXI9tjJOGO16Y2xJCFQO
 32QyZL_gQ7np74AwctYyRf1VObY6rVANI.UokmuVPW9b5K2MIn9RC_PIu2Cw
 ejH76AUmObsUR6.YJT4VxYp5aLLyy0ldzXCIs8bu_yjrdg3i2jcRMG7togDM
 DgBBJSLFmPOVfQ.4qBjdKLHVQ1LHo3Z8YTqip74Kwd8jWX8Ww7VwpibaB4dY
 EFubt_jNfeY75NINgrJAg4Jr6q8x08Ev9DL5TNnj4JhVGx2JENpEui3iZoqT
 VeSAZGuyGp2tXQbIy1OpVETk-
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Mon, 8 Oct 2012 00:30:09 -0500
From: Andrew Watts <akwatts@ymail.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [REGRESSION]: hibernation issues on 3.5.4/3.5.5
Message-ID: <20121008053006.GA2569@ymail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I am experiencing problems with hibernation (echo disk >
/sys/power/state) on both 3.5.4 and 3.5.5. Note: Problem did not
exist up through 3.5.2 (I skipped 3.5.3).

Upon resume from hibernation, the % loading progress indicator
appears. At some point the image stops loading and the system
reverts to a standard cold-boot sequence.

Logs (attached below) reveal it is erroring out with "Invalid LZO
uncompressed length".

Many thanks for your help.

~ Andy

=======

[    2.354392] PM: Checking hibernation image partition /dev/hda2
[    2.354414] PM: Hibernation image partition 3:2 present
[    2.354415] PM: Looking for hibernation image.
[    2.379577] PM: Image signature found, resuming
[    2.406288] PM: Marking nosave pages: [mem 0x0009f000-0x000fffff]
[    2.406294] PM: Basic memory bitmaps created
[    2.406295] PM: Preparing processes for restore.
[    2.406298] Freezing user space processes ... (elapsed 0.00 seconds) done.
[    2.406604] PM: Loading hibernation image.
[    3.162702] PM: Using 1 thread(s) for decompression.
[    3.162702] PM: Loading and decompressing image data (161994 pages) ...     ^H^H^H^H  0%%^H^H^H^H  1%%^H^H^H^H  2%%^H^H^H^H  3%%^H^H^H^H  4%%^H^H^H^H  5%%^H^H^H^H  6%%^H^H^H^H  7%%^H^H^H^H  8%%^H^H^H^H  9%%^H^H^H^H 10%%^H^H^H^H 11%%^H^H^H^H 12%%^H^H^H^H 13%%^H^H^H^H 14%%^H^H^H^H 15%%^H^H^H^H 16%%^H^H^H^H 17%%^H^H^H^H 18%%^H^H^H^H 19%%^H^H^H^H 20%%^H^H^H^H 21%%^H^H^H^H 22%%^H^H^H^H 23%%^H^H^H^H 24%%^H^H^H^H 25%%^H^H^H^H 26%%^H^H^H^H 27%%^H^H^H^H 28%%^H^H^H^H 29%%^H^H^H^H 30%%^H^H^H^H 31%%^H^H^H^H 32%%^H^H^H^H 33%%^H^H^H^H 34%%^H^H^H^H 35%%^H^H^H^H 36%%^H^H^H^H 37%%^H^H^H^H 38%%^H^H^H^H 39%%^H^H^H^H 40%%^H^H^H^H 41%%^H^H^H^H 42%%^H^H^H^H 43%%^H^H^H^H 44%%^H^H^H^H 45%%^H^H^H^H 46%%^H^H^H^H 47%%^H^H^H^H 48%%^H^H^H^H 49%%^H^H^H^H 50%%^H^H^H^H 51%%^H^H^H^H 52%%^H^H^H^H 53%%^H^H^H^H 54%%^H^H^H^H 55%%^H^H^H^H 56%%^H^H^H^H 57%%^H^H^H^H 58%%^H^H^H^H 59%%^H^H^H^H 60%%^H^H^H^H 61%%^H^H^H^H 62%%
[    7.730534] PM: Invalid LZO uncompressed length
[    7.730743]
[    7.730880] PM: Read 647976 kbytes in 4.56 seconds (142.10 MB/s)
[    7.731616] PM: Error -1 resuming
[    8.224207] PM: Failed to load hibernation image, recovering.
[    8.279520] Restarting tasks ... done.
[    8.279783] PM: Basic memory bitmaps freed
[    8.306034] PM: Hibernation image not present or could not be loaded.
