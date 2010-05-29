Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab0E2Lsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 07:48:47 -0400
Received: from webmail02.domeneshop.no ([194.63.248.28]:34573 "EHLO
	webmail02.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab0E2Lsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 07:48:45 -0400
Content-Disposition: inline
Content-Transfer-Encoding: binary
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MIME::Lite 3.01 (F2.74; T1.18; A1.74; B3.07; Q3.07)
From: uwaysi.bin.kareem@paradoxuncreated.com
To: linux-kernel@vger.kernel.org
Subject: Re: hpet timers gone?
Date: Sat, 29 May 2010 13:16:46 +0200
X-Remote-Address: 91.186.70.220
X-User-Agent: Opera/9.63 (Windows NT 5.1; U; en) Presto/2.1.1
X-Mailer: Domeneshop webmail 1.07 (2008-04-23)
X-Moam-Version: 0.93
Message-Id: <E1OIK22-0000J7-7P@webmail02.domeneshop.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Have you enabled ACPI in the BIOS and kernel config? AFAIK, HPET timers, need some backup timers, for HPET to be enabled.
