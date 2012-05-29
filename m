Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab2E2XDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 19:03:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62637 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2E2XDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 19:03:33 -0400
MIME-Version: 1.0
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 30 May 2012 00:55:47 +0200
Message-ID: <CA+1xoqdUbPHJHC7C5AZaZL75-NMXJX13du1uwbFEr3c8EE2jSg@mail.gmail.com>
Subject: Hard lockup and hang
To: "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tool guest, I've started to
observe an odd behavior with today's linux-next (May 29). I would
occasionally see the following message:

  [ 4130.415117] Kernel panic - not syncing: Watchdog detected hard
LOCKUP on cpu 1

But without any dump before (or after) it, and without the reboot I'm
supposed to see.

Any changes recently which can explain this behavior?
