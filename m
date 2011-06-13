Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab1FMSlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:41:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49869 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab1FMSlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:41:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xImuxdqYn1o7kOkCD3Lut5Xu13HDckbs1+9vZUYuk3Tc1CoSNYXGzc/0ZUWYCntcYW
         BBeJHEHM/NGmR902oso7jUjpd96aykHqm7EIGYZCPRxp6KoGNO+dB9eTSvlUFwVPgHrq
         jb9A85PU+lshyox2OFyz2GReoxhnQM1gOhCzA=
MIME-Version: 1.0
In-Reply-To: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
References: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 13 Jun 2011 20:41:08 +0200
X-Google-Sender-Auth: g7e_RuicQr-V0o3-5GBtIIbQ7Tk
Message-ID: <BANLkTimBan7tqAOA8rN8Encoi_rWQJfuYQ@mail.gmail.com>
Subject: [PATCH 0/8] M68k SCSI compile warning fixes
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[corrected the subject]

       Hi James,

These patches fix several compile warnings on m68k.
As I don't have the hardware, I couldn't run test them, though.

 b/drivers/scsi/atari_NCR5380.c |    5 +++
 b/drivers/scsi/atari_scsi.c    |    1
 b/drivers/scsi/mac_scsi.c      |    2 -
 b/drivers/scsi/sun3_NCR5380.c  |    2 -
 b/drivers/scsi/sun3_scsi.c     |    2 -
 b/drivers/scsi/sun3_scsi_vme.c |    2 -
 drivers/scsi/mac_scsi.c        |   12 -------
 drivers/scsi/sun3_NCR5380.c    |   65 +++--------------------------------------
 drivers/scsi/sun3_scsi.c       |    9 ++++-
 drivers/scsi/sun3_scsi_vme.c   |    9 ++++-
 10 files changed, 31 insertions(+), 78 deletions(-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
