Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab1JJWWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 18:22:42 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:36465 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752744Ab1JJWWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 18:22:41 -0400
X-Authenticated: #1242716
X-Provags-ID: V01U2FsdGVkX1+XPv5EGv2XwnikDQxPDga/Z8R7Rsl50cDlBd0UI1
	2G1UzdSZN6X0Q1
Message-ID: <4E93702C.8070707@gmx.de>
Date: Tue, 11 Oct 2011 00:22:36 +0200
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Firefox/7.0.1 SeaMonkey/2.4.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org
Subject: [Patch 0/2] gpio-pca953x: fix gpio_base and add verbosity
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches change gpio-pca953x.c for the following purposes:
    - set gpio_base to -1, in case no kind of platform data was provided
    - verbose output of the gpiochip details (gpio range, chiptype,
irq), like the gpio-pcf857x driver already does.

