Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352Ab0CPPWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:22:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49985 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab0CPPWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:22:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=Mzc+w5mlaKBL6eP8uWwy4qc98i53jDXDEl26nby/dFEJKGyZ8SzFB29nEFIXTxHGqC
         OyL3iOIRYXSP5nxBjA5xreGkN+QaRDM1fzVwQeYnipsTbzNGHB/KV0VpBMLmGaUbr6s8
         dLJyuAUeVv3Beumy0h3IGDeUinwJmqs/43tv4=
MIME-Version: 1.0
From: Ulrich Drepper <drepper@gmail.com>
Date: Tue, 16 Mar 2010 08:19:36 -0700
Message-ID: <a36005b51003160819p21871af4t48a08a502afb67b5@mail.gmail.com>
Subject: ACPI spam
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On one machine I've used using a recent kernel I see tons of messages like

Mar 16 10:54:52 intel-d3cf1-01 kernel: ACPI Exception: AE_NOT_EXIST,
while evaluating GPE method [_L01] (20090903/evgpe-568)
Mar 16 10:54:53 intel-d3cf1-01 kernel: ACPI Error: No handler for
Region [ECF2] (ffff88013b69c978) [EmbeddedControl]
(20090903/evregion-319)
Mar 16 10:54:53 intel-d3cf1-01 kernel: ACPI Error: Region
EmbeddedControl(3) has no handler (20090903/exfldio-295)

This is reported hundreds of times.

Shouldn't these messages be rate-limited?  Aside from the reason being fixed.
