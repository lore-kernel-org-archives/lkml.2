Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab2CLOZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 10:25:12 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48029 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab2CLOZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 10:25:09 -0400
Date: Mon, 12 Mar 2012 14:24:44 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Olof Johansson <olof@lixom.net>
Cc: x86@kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, matt.fleming@intel.com
Subject: Re: [PATCH v5 5/5] x86: efi: allow basic init with mixed 32/64-bit
 efi/kernel
Message-ID: <20120312142444.GB11969@srcf.ucam.org>
References: <1329081869-20779-1-git-send-email-olof@lixom.net>
 <1329081869-20779-6-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329081869-20779-6-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As you say, this isn't a full solution - we'll need additional thunking 
to fix the general case. But it's a step in the right direction and it's 
better than what we have now, so ACK.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
