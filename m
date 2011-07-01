Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab1GASVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 14:21:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60786 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1GASU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 14:20:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Please submit platform trees for inclusion in arm-soc.git v3.1
Date: Fri, 1 Jul 2011 20:18:14 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107012018.14619.arnd@arndb.de>
X-Provags-ID: V02:K0:LS8CVT8QTxU9diRpI5jRbJPg5SSM/9e1dh294ZP4WEO
 expmbNWK8sBjfFU7Tub7splZheYI4gGuzoyo0s3ch78BAQmdfI
 w+bs9RSDCTudkEb/HzNViFW0phDEXCDItsg6cYahVnuTsYNdUr
 NXAEc2+0TIOY+i4owxC/uoXZAytv09NA9KESKOuutWAClEIQS2
 LF/3xn6KqJkdQxQYIVTpg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear subarchitecture maintainers,

Time is running out for the current cycle, so any changes that you
want to see merged in linux-3.1 through the arm-soc tree should be
submitted in form of pull-requests very soon.

We currently have three per-subarchitecture branches (omap, stericsson,
zynq) and there is plenty of room for more.

The rules are roughly:

* We are here to help subarchitecture maintainers coordinate the merging
  into the upstream torvalds/linux-2.6 tree. If we are not helpful, do
  let us know.

* We are also there to prevent crap from getting merged. If you see
  patches in someone else's pull request that shouldn't be there,
  let us know, too.
 
* If you don't hear back from anyone within a few days, send a friendly
  reminder.

* If you currently merge your patches upstream through RMK's tree,
  you can keep doing so.

* All patches need to have been reviewed properly and are considered
  ready for the next merge window.

* Once a patch gets into arm-soc, it stays in and you have to submit
  follow-up patches for fixing bugs, not send replacement patches.

* If there is a serious problem with a patch that was already merged,
  it will get reverted. If there is a serious problem with an entire
  branch, it will not make it in the merge window unless the problems
  are addressed.

* Group patch series by intention, e.g
   * bug fixes
   * cleanups and simplifications
   * conversion to device tree
   * support for new features
    ...
  Don't worry if a pull request for one branch only has a single commit.
  We can easily group it with similar branches when submitting onward.

* There is a single master branch that contains a merge of all the
  other branches that are intended for the next merge window. This
  branch is not yet part of linux-next, but will be. Before sending
  a pull request, check if your branch merges with the master, and
  mention any conflicts that when asking for a pull.
  Small conflicts are ok, any serious conflicts need to be deal with
  case-by case.

* Do not base code on arm-soc.git/master! All pull requests should be
  relative to an -rc release in torvalds/linux-2.6.git when possible.
  If you have dependencies on another branch, they need to be
  mentioned in the pull request, so we can base it on top of that
  branch, and wait for it to get merged upstream before asking Linus
  to pull yours.

* Cleanups across multiple subarchitectures are ok, and should go into
  one branch for the entire work.

* Bug fixes should be audited to see if they apply to stable kernels.
  If you have a bug that should be applied on older kernel versions,
  add 'Cc: stable@kernel.org' to the changelog.

* New subarchitectures need to use the flattened device tree and contain
  no board specific files any more.

* New board support without using flattened device tree is ok in some
  cases, especially when it's clear that you are making an effort to
  avoid this in the future. Adding a lot of features and board code
  is not ok when you don't also work on cleaning up the mess we already
  have.
  
* Anything that moves code out of arch/arm is very welcome in general,
  including:
  * removal of nonworking and obsolete code that nobody will miss
  * moving device drivers into their respective subsystems
  * consolidation of identical code across boards and/or subarchitectures

* You can send pull requests at any time, there is no specific merge
  window for the arm-soc tree. If you send them just before Linus
  opens his merge window, or during that merge window, your patches will
  probably have to wait for another release. This obviously depends
  on the complexity and kind of patch. Simple bug fixes get always
  forwarded for the current kernel, cleanups for the coming merge window,
  and new features might need a bit extra time.

I have put everyone listed as a maintainer for arch/arm/mach-*/ on bcc
in this mail to let you know about it without having an endless cc list.

	Arnd
