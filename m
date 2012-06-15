Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2FOA2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:28:17 -0400
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:38161
	"EHLO l.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab2FOA2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:28:16 -0400
X-Greylist: delayed 1039 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2012 20:28:15 EDT
Message-ID: <4FDA7D20.1090004@chelsio.com>
Date: Thu, 14 Jun 2012 17:09:04 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110923 Thunderbird/7.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: pull request: linux-firmware: update cxgb4 firmware
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can you please pull from the following URL?
     git://git.chelsio.net/pub/git/linux-firmware.git for-upstream

Commit 54f64ed387a5561d4c9fe698d57343b108481cf5 update the firmware for 
cxgb4.

The following changes since commit 4c79292308ead42fc786c8e189921196ccc298ff:

   build: Implement minimal GNOME Build API (2012-05-25 20:41:26 +0100)

are available in the git repository at:
   git://git.chelsio.net/pub/git/linux-firmware.git ..BRANCH.NOT.VERIFIED..

Divy Le Ray (1):
       cxgb4: update firmware to revision 1.4.23.0

  WHENCE                  |    2 +-
  cxgb4/t4fw-1.4.16.0.bin |  Bin 298496 -> 0 bytes
  cxgb4/t4fw-1.4.23.0.bin |  Bin 0 -> 326144 bytes
  cxgb4/t4fw.bin          |    2 +-
  4 files changed, 2 insertions(+), 2 deletions(-)
  delete mode 100644 cxgb4/t4fw-1.4.16.0.bin
  create mode 100644 cxgb4/t4fw-1.4.23.0.bin

Cheers,
Divy
