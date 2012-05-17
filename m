Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab2EQIbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:31:51 -0400
Received: from mga10.intel.com ([192.55.52.92]:5845 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753969Ab2EQIbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:31:48 -0400
Subject: Re: [PATCH] x86-64: use EFI to deal with platform wall clock
From: Matt Fleming <matt.fleming@intel.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com
In-Reply-To: <4FB3C0ED020000780008418E@nat28.tlf.novell.com>
References: <4FB265AB0200007800083CC5@nat28.tlf.novell.com>
	 <20120515124707.GB25248@srcf.ucam.org>
	 <4FB273EB0200007800083D32@nat28.tlf.novell.com>
	 <20120515132006.GA26196@srcf.ucam.org>
	 <4FB3B734020000780008415D@nat28.tlf.novell.com>
	 <20120516123912.GA20990@srcf.ucam.org>
	 <4FB3C0ED020000780008418E@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 17 May 2012 09:31:21 +0100
Message-ID: <1337243481.27692.32.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 13:59 +0100, Jan Beulich wrote:
> I shall give that a try then. It would imply that we don't need
> phys_efi_get_time() then anymore. I don't have a 32-bit EFI box
> though to test that things don't break there...

I can test out 32-bit EFI, or at least find someone with access to such
a system.

