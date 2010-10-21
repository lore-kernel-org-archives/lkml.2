Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab0JUNyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:54:37 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59754 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359Ab0JUNyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:54:36 -0400
Date: Thu, 21 Oct 2010 14:54:29 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Vernon Mauery <vernux@us.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linux Documentation <linux-doc@vger.kernel.org>,
        Platform driver x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: [Patch] IBM Real-Time "SMI Free" mode driver -v7
Message-ID: <20101021135429.GC22133@srcf.ucam.org>
References: <20101005224718.GC4046@lucy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005224718.GC4046@lucy>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied, thanks. It'd be nice if we didn't have to rely on DMI, 
especially since enterprise customers often end up running later kernels 
- is there any other way to determine that this is safe to load? Could 
we just limit it to IBM systems in a server/blade chassis and then check 
for the _RTL_ area?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
