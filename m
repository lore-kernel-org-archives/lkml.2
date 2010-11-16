Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab0KPUts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:49:48 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61210 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab0KPUtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:49:47 -0500
Subject: [PATCH 0/5] Series short description
To: linux-kernel@vger.kernel.org
From: John Bonesio <bones@secretlab.ca>
Cc: linuxppc-dev@lists.ozlabs.org, jdl@jdl.com, glikely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, david@gibson.dropbear.id.au
Date: Tue, 16 Nov 2010 12:49:43 -0800
Message-ID: <20101116204917.12146.39851.stgit@riker>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements a set of changes to refactor dts (device tree
source) files for systems using the mpc5200b SoC.

The dtc changes allow a base dts to be defined in a common dts file included
with '/include/ <filename>'. This base dts can then be updated and modified
by merging in a second device tree defined in the system specific dts file.

The rest of the changes are the refactoring of the mpc5200b dts files.

---

John Bonesio (5):
      scripts: dtc: Merge in changes from the dtc repository
      powerpc/5200: dts: rename nodes to prepare for refactoring dts files
      powerpc/5200: dts: remove unused properties
      powerpc/5200: dts: Remove incorrect combatible strings
      powerpc/5200: dts: refactor dts files


 arch/powerpc/boot/dts/cm5200.dts    |  198 +++----------------------
 arch/powerpc/boot/dts/digsy_mtc.dts |  179 +++--------------------
 arch/powerpc/boot/dts/lite5200b.dts |  210 ++-------------------------
 arch/powerpc/boot/dts/media5200.dts |  216 +++------------------------
 arch/powerpc/boot/dts/motionpro.dts |  198 +++----------------------
 arch/powerpc/boot/dts/mpc5200b.dtsi |  276 +++++++++++++++++++++++++++++++++++
 arch/powerpc/boot/dts/mucmc52.dts   |  176 ++++++----------------
 arch/powerpc/boot/dts/pcm030.dts    |  201 ++-----------------------
 arch/powerpc/boot/dts/pcm032.dts    |  205 ++------------------------
 arch/powerpc/boot/dts/uc101.dts     |  162 ++++-----------------
 10 files changed, 499 insertions(+), 1522 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/mpc5200b.dtsi

-- 
Signature
