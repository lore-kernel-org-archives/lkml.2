Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab2BALIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 06:08:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55869 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab2BALIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 06:08:24 -0500
From: Franck Bui-Huu <fbuihuu@gmail.com>
To: linux@dominikbrodowski.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] cpupower tool: allow building output to be in a separate directory
Date: Wed,  1 Feb 2012 12:08:17 +0100
Message-Id: <1328094500-19393-1-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.7.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dominik,

This small patchset gives to the user the ability to build cpupower
tool even if the source code is stored in a read-only location.

Patches #1 and #2 are just minor cleanup in order to ease patch #3
which adds the functionnality.

Please consider.

Franck Bui-Huu (3):
  cpupower tool: remove use of undefined variables from the clean target of the top makefile
  cpupower tool: makefile: simplify the recipe used to generate cpupower.pot target
  cpupower tool: allow to build in a separate directory

 tools/power/cpupower/Makefile       |   93 +++++++++++++++++++++-------------
 tools/power/cpupower/bench/Makefile |   23 ++++++---
 2 files changed, 72 insertions(+), 44 deletions(-)

-- 
1.7.7.4

