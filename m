Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab1LKWNL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 17:13:11 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:43735 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab1LKWNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 17:13:05 -0500
Date: Mon, 12 Dec 2011 07:13:03 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org
Subject: recent regression: after resume the mouse and X is extremely slow
Message-ID: <20111211221303.GA8710@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

(please cc)

I am running 3.2.0-rc5 and experience the following problem which 
was introduced in one of the last commit, but I have no idea when it
was. When I resume from a suspend to ram, the X is suddently
extremely slow. I cannot even log in/unlock the screen. It takes
minutes to show the dialog, the mouse moves, no crawls millimeter
per milimeter. THe only way is to restart X.

I have found *NO* traces on what is going on. The cpu usage is low,
there are no messages in the syslog, it all looks rather normal,
besides that it is unusable.

In recent times I have only changed two things: - remove the the 
CONFIG_ACPI_PROCFS_POWER setting and increase the MAX CPU to 4 from 2.
And ugraded from some intermedieate (git between rc4 and rc5)
to rc5.

I am now reverting the CONFIG changes and will see if that makes a difference.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
"I don't know, " said the voice on the PA, "apathetic
bloody planet, I've no sympathy at all."
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
