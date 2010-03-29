Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab0C2Nkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:40:42 -0400
Received: from lucidpixels.com ([75.144.35.66]:60704 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab0C2Nkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:40:40 -0400
Date: Mon, 29 Mar 2010 09:40:38 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: EDAC: Is it possible to calculate which piece of memory is bad?
Message-ID: <alpine.DEB.2.00.1003290939340.27175@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I see the following errors:

EDAC MC0: CE page 0x8abba, offset 0xa10, grain 8, syndrome 0x4758, row 0, channel 0, label "": k8_edac
EDAC MC0: CE - no information available: k8_edac Error Overflow set
EDAC k8 MC0: extended error code: ECC chipkill x4 error
EDAC k8 MC0: general bus error: participating processor(local node origin), time-out(no timeout) memory transaction type(generic read), mem or i/o(mem access), cache level(generic)

Is it possible to use the page or offset to calculate which DIMM is having a
problem?

Justin.

