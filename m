Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab0JDMQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 08:16:24 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:33722 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755569Ab0JDMQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 08:16:18 -0400
Date: Mon, 4 Oct 2010 14:06:10 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] staging: remove duplicated includes
Message-ID: <20101004140610.2c8fb91a@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches remove duplicated includes of guarded headers.

Nicolas Kaiser (3):
  staging/lirc: remove duplicated include
  staging/spectra: remove duplicated includes
  staging/tidspbridge: remove duplicated include
