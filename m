Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab0E1RZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:25:13 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41375 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab0E1RZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:25:09 -0400
Date: Fri, 28 May 2010 18:25:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Julia Lawall <julia@diku.dk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Mattia Dongili <malattia@linux.it>, platform-driver-x86@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 9/11] drivers/platform/x86: Eliminate a NULL pointer
	dereference
Message-ID: <20100528172500.GE30936@srcf.ucam.org>
References: <Pine.LNX.4.64.1005271436460.5422@ask.diku.dk> <201005270921.43049.dmitry.torokhov@gmail.com> <Pine.LNX.4.64.1005271831520.5422@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005271831520.5422@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied this version, thanks.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
