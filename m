Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab0FHRnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 13:43:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:55568 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab0FHRnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 13:43:35 -0400
Subject: [STAGING] Spectra Flash Translation Layer
From: David Woodhouse <dwmw2@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 18:43:30 +0100
Message-ID: <1276019010.22896.13.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-6.fc13) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, please pull from
	git://git.infradead.org/users/dwmw2/spectra-2.6.git

This was previously known as the 'Moorestown NAND flash driver'.

In fact, we have a proper MTD driver for that hardware now, and the only
part we want is the FTL -- the pseudo-filesystem which pretends to be a
disk drive.

It's a silly approach to using flash; we ought to be using proper flash
file systems on it instead. But we need this on at least part of the
flash for compatibility with legacy firmware.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

