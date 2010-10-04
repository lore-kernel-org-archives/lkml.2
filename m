Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab0JDLq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 07:46:56 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:59456 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754076Ab0JDLqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 07:46:55 -0400
X-ClientAddr: 91.119.0.188
Date: Mon, 4 Oct 2010 12:24:36 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] arm: remove duplicated includes
Message-ID: <20101004122436.7092868f@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-m2soft-MailScanner-Information: Please contact the ISP for more information
X-m2soft-MailScanner-ID: o94AXLMM020440
X-m2soft-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-m2soft-MailScanner-From: nikai@nikai.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches remove duplicated includes of guarded headers.

Nicolas Kaiser (5):
  arm/nomadik: remove duplicated include
  arm/tegra: remove duplicated include
  arm/shmobile: remove duplicated include
  arm/omap: remove duplicated include
  arm/davinci: remove duplicated include
