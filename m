Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab0LMVOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:14:34 -0500
Received: from web31808.mail.mud.yahoo.com ([68.142.207.71]:26565 "HELO
	web31808.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756486Ab0LMVOc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:14:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=stxa7nPb75/8FON8ajm5UKry4Z892YpnJDP9x2xcwzTnPQIFIyODJLZtGKOoRS0LD1DzDiUO9f/lrCOn2UIjdIXU090vLt8PeM07c+kmp27M4sGGa5bevuC0iKCs9aP9AgxKKChBmxD87rut6u+d85Sqvef030RLwBr2NbB7CdE=;
Message-ID: <150741.23411.qm@web31808.mail.mud.yahoo.com>
X-YMail-OSG: w2NoKtAVM1mslm3f7d9ZeE.9j.IF3rw4pPCNl01Peg6ojiX
 9Xd12gPJg8CqO.W4YbG51oHVtGmQVwRYtnQQ4cRnumr2kdJzdyka_Z2QYrFU
 mWoG2aSPsy7gwcaZShAiAH_vvIVRxGkRyEBa3b0K0m7mIFj8n5SEHqewIWwd
 d4VqidXIDTQep97_W8tMNBU.2axWnjYn9XtWEAtxivD9pfC7h1vbVI4U33bV
 Q8rAtVtcyffuToWwbhvF714kpJb.AafxL_u.Uia6b0vAp4TKKf_JBGi8axhT
 afIvnW.CJx40zKiq79Q7hpag7R8lIvXrEqBxYNVpQOSPDb_AL4rE3X1.Aeiz
 GBnCfLBFEKJGQWlFvi4YhEmB66U3U3rmU3C7LGB7jWLyeN5KPA.5IaerJX5j
 eJY.p8bg9uuKO
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Mon, 13 Dec 2010 13:14:31 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: [ANNOUNCE] UAS uasp.c driver available on github
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uasp.c driver is available on github at https://github.com/ltuikov/linux-2.6. The free-linux branch is a branch off of the master branch. The free-linux branch contains the following:

 * uasp.c driver which allows you to connect to USB Attached SCSI (UAS) devices and use them as SCSI devices.

The free-linux branch also includes the following patches:

 * 6e5eba [USB] Use normalized sense when emulating autosense,
 * 245423 [SCSI] Retrieve the Caching mode page, and
 * 67869f [BLOCK] Preliminary increasing tag sequence implementation.

The first two of those patches, 6e5eba and 245423, have been accepted into topic branches and should be merged in the next (or current) kernel release.

The 67869f patch is needed to eliminate TMF processing race conditions in case of multiple application clients issuing commands to the same I_T nexus as I described here: http://marc.info/?t=128902350400001&r=1&w=2.

    Luben

