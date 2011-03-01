Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab1CAP1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:27:07 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58370 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628Ab1CAP1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:27:01 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: =?UTF-8?q?=5BPATCH=200/8=5D=20amd64=5Fedac=3A=20Small=20fixlets?=
Date: Tue,  1 Mar 2011 16:26:48 +0100
Message-Id: <1298993216-19434-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

the following fixes address small issues caught when building
amd64_edac.c the with 'make W=1' switch¹. They'll land ontop the
patchset at http://marc.info/?l=linux-kernel&m=129735813831174&w=2 if
there are no objections.

Thanks.

¹ http://marc.info/?l=linux-kernel&m=129828622020066&w=2
