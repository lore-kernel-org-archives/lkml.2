Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab0DZSBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 14:01:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:34602 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753664Ab0DZSBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 14:01:36 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+ooIB9C86oTOavF/xN3NLpZsb5tJOSNMMggCrVxW
	YImlP++aqAfu/g
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, corbet@lwn.net
Subject: viafb suspend & resume
Date: Mon, 26 Apr 2010 18:09:43 +0000
Message-Id: <1272305387-4872-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68000000000000005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This little patch series tries to implement suspend and resume in a sane way
that should work on all IGPs supported. It's not yet error free but should be
a good start. It is based on the second version of Jon's first patch series.


Thanks,

Florian Tobias Schandinat


Deepak Saxena (1):
      Minimal support for viafb suspend/resume

Florian Tobias Schandinat (3):
      viafb: restore display on resume
      viafb: make suspend and resume work (on all machines?)
      viafb: fix hardware acceleration for suspend & resume

