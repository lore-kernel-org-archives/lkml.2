Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1AGVPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 16:15:09 -0500
Received: from lo.gmane.org ([80.91.229.12]:60907 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab1AGVPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 16:15:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
Mail-Followup-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
From: Nikolaus Rath <Nikolaus@rath.org>
Subject: CPU Initiated DMA
Date: Fri, 07 Jan 2011 15:55:29 -0500
Message-ID: <87mxncv3ge.fsf@inspiron.ap.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: ebox.rath.org
Mail-Copies-To: never
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Cancel-Lock: sha1:r8hBL4ImWY4sHtS3RZdC3jR15KY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I want to write a driver for a rather dumb PCI card, which cannot become
bus master itself. Is it possible to use a DMA controller on the
mainboard to still transfer data to the card without occupying the CPU?

(I believe this is the way DMA used to work on ISA cards, but do recent
x86 systems still have a DMA controller for the CPU?)

Any pointers are greatly appreciated. I looked into "Linux Device
Drivers", but the DMA chapter seems to be only about the device becoming
busmaster.



Best,

   -Nikolaus

-- 
 »Time flies like an arrow, fruit flies like a Banana.«

  PGP fingerprint: 5B93 61F8 4EA2 E279 ABF6  02CF A9AD B7F8 AE4E 425C

