Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab2DQWC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 18:02:57 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45986 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2DQWC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 18:02:56 -0400
MIME-Version: 1.0
Date: Tue, 17 Apr 2012 23:02:55 +0100
Message-ID: <CAAMvbhFCzKH-4_kspOfgCOEPZpsr1MVoVJogKmupF=FgtXE4GQ@mail.gmail.com>
Subject: malloc() failure counter
From: James Courtier-Dutton <james.dutton@gmail.com>
To: LKML Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If I have a user application that tries a malloc() or a calloc() call,
and this call fails, is there any way to report this to a global stats
counter, like the ones in /proc/meminfo
Is there any way to find out that a malloc call made by a user program failed?

Kind Regards

James
