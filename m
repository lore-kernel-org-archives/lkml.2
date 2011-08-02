Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1HBVDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 17:03:35 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49154 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab1HBVDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 17:03:31 -0400
Date: Tue, 2 Aug 2011 22:03:26 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>
Subject: Re: [PATCH] efivars: fix warnings when CONFIG_PSTORE=n
Message-ID: <20110802210326.GA2606@srcf.ucam.org>
References: <4e3864a227625bd7d6@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e3864a227625bd7d6@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 01:57:06PM -0700, Luck, Tony wrote:
> drivers/firmware/efivars.c:161: warning: ‘utf16_strlen’ defined but not used
> utf16_strlen() is only used inside CONFIG_PSTORE - put same #ifdef around the
> definition of the function too.
> 
> drivers/firmware/efivars.c:602: warning: initialization from incompatible pointer type
> Between v1 and v2 of this patch series we decided to make the "part" number
> unsigned - but missed fixing the stub version of efi_pstore_write()
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
