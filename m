Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab0KIRwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:52:15 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:42119 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab0KIRwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:52:14 -0500
X-Greylist: delayed 497 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Nov 2010 12:52:13 EST
Date: Tue, 9 Nov 2010 18:43:54 +0100
From: Andreas Mohr <andi@lisas.de>
To: Ramya Desai <ramya.desaigmail!com@rhlx01.hs-esslingen.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Doubt about CRTSCTS preprocessor macro definition in termbits.h
 file
Message-ID: <20101109174353.GA19069@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> My question is, the c_cflag is a 32 bit value member and the CRTSCTS
> is a 48 bit value. How CRTSCTS is accommodates into c_cflag variable?

One word: octal ;)

HTH & TFR (well... Thanks For Review),

Andreas Mohr
