Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0GLUle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:41:34 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:48249 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753500Ab0GLUlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:41:31 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: hI1c0KsVM1nXxBHSEV2u4sNY14LjmkTEDWeX7Wdajh7v1.lnGwaGOh2A8ATSxvCK9ggM2moPaJBsRJyCfHuuB52iU.9cKj3wd8SYN4s7sPLjqjQBU.G2WTV96RcaRbd6g8aA33Keomd10k7J4QWU_dK1noHpvUmeqwkoApbROjQqEog_OUOOr77jTCJK5rZWUOcZKWLQ.4QDb_t6FwkZ5HHdt2pdi8f4kCAGJkzJ99CVH7lxtFOkTec59M9gBPeSxdffPenymgAMEcUV84efigaF4laLry9pgFj93jpYPR96FgKqKuY91pV46Pby_D_YA9DJCrauUlwizcFn7VhJuLvkh4kdQaR4sJF9s4lHahvw.rE757tYjO0FqJwgdCrdBX0-
X-Yahoo-Newman-Property: ymail-3
Subject: [ANNOUNCE] lio-core-backports.git tree now available!
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: nab@risingtidesystems.com
Content-Type: text/plain
Date: Mon, 12 Jul 2010 13:31:45 -0700
Message-Id: <1278966705.16667.209.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a quick resend to fix the subject line so that the ANNOUNCE bots
on LKML correctly pick up this thread.

-----------------------------------------------------------------------

Greetings all,

It is my pleasure to announce that the lio-core-backports.git tree
containing the LIO v3.1.x 'out of tree' kernel module builds is now
publicaly available!  This tree allows the LIO code to run on any
unmodified kernel from recent v2.6.3[1,2] stable kernels that are
shipping with RHEL6, OpenSuse 11 and Ubuntu Lucid Lynx going back to
v2.6.18 w/ RHEL5.  The code is available via gitweb at:

http://risingtidesystems.com/git/?p=lio-core-backports.git;a=summary

This tree has been maintained for the last 8 months tracking upstream
lio-core-2.6.git changes for Rising Tide Systems customers, and is now
being made available as a service to the community.

This tree contains the v3.1.x code for TCM/ConfigFS (Target_Core_Mod)
and the LIO-Target iSCSI fabric module.  This tree also includes a
backport of the configfs filesystem, which is required in order for LIO
to run on pre v2.6.27 kernels due to bugs in the handling of config
subsystem in logic the original fs/configfs code that was fixed upstream
fall 2008.  Finally, the tree is capable of generating RPM and DEB
kernel packages on many propular distributions.

This tree contains complete support of all SPC-4 feature bits for
Persistent Reservations and ALUA multipath.  This same logic has been
certified for VMWare VSphere v4 from multiple independent hardware
vendors who are now shipping LIO v3.x code.

Information has been added to LIO wiki download page at:

http://linux-iscsi.org/index.php/Downloads

and build README containing the mini-HOWTO is available here:

http://risingtidesystems.com/git/?p=lio-core-backports.git;a=blob_plain;f=README;hb=HEAD

Best,

--nab

