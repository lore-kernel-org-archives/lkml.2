Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2GPN1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 09:27:08 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:49106 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab2GPN1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:27:06 -0400
Date: Mon, 16 Jul 2012 22:27:05 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org
Subject: regression 918227bb -> -rc7: does not wake up from sleep
Message-ID: <20120716132705.GC21748@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

(please cc)

I recently upgraded from git918227bb to rc7 and suddenly my laptop
does not wake up from sleep again, all dead.

I will try to bisect as soon as possible, but I am on a conference
and give two talks, so not so much time.

Is the above problem known? intel graphics card.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
BANFF
Pertaining to, or descriptive of, that kind of facial expression which
is impossible to achieve except when having a passport photograph
taken.
			--- Douglas Adams, The Meaning of Liff
