Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab0LIPUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:20:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40123 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab0LIPUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:20:12 -0500
Message-ID: <4D00F390.6020609@zytor.com>
Date: Thu, 09 Dec 2010 07:19:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Edouard Gomez <ed.gomez@free.fr>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Thomas Backlund <tmb@mandriva.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Dell Precision WorkStation 690 reboot quirk
References: <4d8b4b3a1d3c6034b868.1291822674@egomez.in.mobiclip.com> <20101209151633.GA7273@srcf.ucam.org>
In-Reply-To: <20101209151633.GA7273@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 07:16 AM, Matthew Garrett wrote:
> My testing suggests that Windows never uses the BIOS-style reboot 
> approach, so this seems wrong. Does reboot=acpi work for you?

We have talked about switching to reboot=acpi by default for machines
newer than <some date>... this would be good to do.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

