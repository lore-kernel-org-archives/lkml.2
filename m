Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab0G3X34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 19:29:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45054 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab0G3X3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 19:29:55 -0400
Message-ID: <4C53605A.8050603@zytor.com>
Date: Fri, 30 Jul 2010 16:29:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        mingo@elte.hu, Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH 04/15] x86,kgdb: Individual register get/set for x86
References: <1280517456-1167-1-git-send-email-jason.wessel@windriver.com> <1280517456-1167-5-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1280517456-1167-5-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2010 12:17 PM, Jason Wessel wrote:
> Implement the ability to individually get and set registers for kdb
> and kgdb for x86.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: H. Peter Anvin <hpa@zytor.com>
> CC: x86@kernel.org

Looks reasonable to me (GDB_PS drove me nuts at first, thinking it was a
typo for SP; I gather that like GDB_PC it's a gratuitous renaming of x86
registers to match some other CPU convention, but that's presumably a
GDB issue and not a kernel one.)

	-hpa
