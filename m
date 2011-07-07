Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1GGLjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 07:39:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54588 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577Ab1GGLjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 07:39:08 -0400
Date: Thu, 7 Jul 2011 12:38:45 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tony.luck@intel.com
Subject: Re: [PATCH v2] efi: Fix argument types for SetVariable()
Message-ID: <20110707113845.GA10882@srcf.ucam.org>
References: <1307388985-7852-1-git-send-email-mjg@redhat.com>
 <1309985329-15034-1-git-send-email-mjg@redhat.com>
 <20110707093305.GA15058@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707093305.GA15058@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 11:33:05AM +0200, Ingo Molnar wrote:

> Please send a patch against latest -tip, we've got EFI changes in 
> tip:x86/efi and your patch conflicts.

The original version introduced a warning, thsi was intended to replace 
it. Is -tip not rebased?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
