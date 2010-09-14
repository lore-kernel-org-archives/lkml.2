Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab0INJw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 05:52:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51540 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0INJw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 05:52:28 -0400
MIME-Version: 1.0
X-Originating-IP: [192.55.54.36]
Date: Tue, 14 Sep 2010 17:52:26 +0800
Message-ID: <AANLkTin9Ry6hCBciLkg2ExgERv9SHq5vO-Zvxy3Ei_JJ@mail.gmail.com>
Subject: Why not make LKML-Reference useful?
From: Lin Ming <lin@ming.vg>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What's LKML-Reference in the kernel git log?
In my understanding, it's a link to the original discussion of the
patch on LKML, for example

LKML-Reference: http://marc.info/?l=linux-kernel&m=128445596126705&w=2

But I never see such a link in the LKML-Reference of the git log.

$cd linux-2.6
$git log | grep LKML-Reference

    LKML-Reference: <201008300127.o7U1RC6Z044051@www262.sakura.ne.jp>
    LKML-Reference: <20100913102541.20260.85700.stgit@ltc236.sdl.hitachi.co.jp>
    LKML-Reference: <20100913121903.GB22238@darkstar>
    LKML-Reference:
<AANLkTi=8m4g01wZPacySoF7U0PevTNVgJoZZrHiUD-pN@mail.gmail.com>
    LKML-Reference: <new-submission>
    LKML-Reference: <new-submission>
    LKML-Reference: <20100822082003.GB7365@infradead.org>
    LKML-Reference: <4c8a1686.aae9d80a.5aa4.5e35@mx.google.com>
    LKML-Reference:
<d40c60f4b036a26db8492848695bdafaa3b42791.1284267142.git.joe@perches.com>
    LKML-Reference: <4C8B2AFA.2000705@kernel.org>
    LKML-Reference: <4C8B2A9A.1040303@kernel.org>
    LKML-Reference: <1284150773.402.122.camel@laptop>
    LKML-Reference: <1284159350-19841-3-git-send-email-venki@google.com>
    LKML-Reference: <1284159350-19841-2-git-send-email-venki@google.com>
    LKML-Reference: <new-submission>
......

Those LKML-Reference are really useless.

Why not put a link in LKML-Reference?

Thanks,
Lin Ming
