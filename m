Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab1KBNiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 09:38:04 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:47928 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673Ab1KBNiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 09:38:01 -0400
Subject: Re: [PATCH v2] x86, efi: Calling __pa() with an ioremap'd address
 is invalid
From: Matt Fleming <matt@console-pimps.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1318592205-11193-1-git-send-email-matt@console-pimps.org>
References: <1318592205-11193-1-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Nov 2011 13:37:57 +0000
Message-ID: <1320241077.3572.81.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For anyone else interested in this patch, the approach is flawed as
detailed in the bug report at, 

	https://bugzilla.redhat.com/show_bug.cgi?id=748516

I'll follow-up with a better solution soon.

-- 
Matt Fleming, Intel Open Source Technology Center

