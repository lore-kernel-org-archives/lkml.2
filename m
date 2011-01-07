Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab1AGW16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:27:58 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37165 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab1AGW15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:27:57 -0500
Date: Fri, 7 Jan 2011 22:27:48 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: ibm-acpi-devel@lists.sourceforge.net,
        Borislav Deianov <borislav@users.sf.net>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI Thinkpad: We must always call va_end() after
	va_start() but do not do so in thinkpad_acpi.c::acpi_evalf()
Message-ID: <20110107222748.GC32575@srcf.ucam.org>
References: <alpine.LNX.2.00.1012241952200.28973@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1012241952200.28973@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied, thanks.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
