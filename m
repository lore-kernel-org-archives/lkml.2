Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2AELW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 06:22:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:53221 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab2AELWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 06:22:25 -0500
Subject: Re: [PATCH 3/5] x86: efi: cleanup config table walking
From: Matt Fleming <matt.fleming@intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
In-Reply-To: <1325610682-24811-4-git-send-email-olof@lixom.net>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
	 <1325610682-24811-4-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 05 Jan 2012 11:22:05 +0000
Message-ID: <1325762525.3635.24.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-03 at 09:11 -0800, Olof Johansson wrote:
> Trivial cleanup, move guid and table pointers to local copies to
> make the code cleaner.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>  arch/x86/platform/efi/efi.c |   61 +++++++++++++++++++-----------------------
>  1 files changed, 28 insertions(+), 33 deletions(-)

Acked-by: Matt Fleming <matt.fleming@intel.com>


