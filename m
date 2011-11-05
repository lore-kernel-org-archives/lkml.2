Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab1KEV1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 17:27:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50464 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750860Ab1KEV1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 17:27:44 -0400
X-Authenticated: #1242716
X-Provags-ID: V01U2FsdGVkX1+cthg5Bdmc3kVaiU0dT9aOlRZn6bsyA/fA0iJaMj
	avPKxYxyvcMVi5
Message-ID: <4EB5AA4C.7000609@gmx.de>
Date: Sat, 05 Nov 2011 22:27:40 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Firefox/7.0.1 SeaMonkey/2.4.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] gpiolib: output basic details and consolidate gpio device
 drivers
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset makes gpiolib output a kernel message, containing GPIO range and device name. Device drivers, containing these or similar information, are consolidated.
