Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab0JKHSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 03:18:47 -0400
Received: from mail.tpi.com ([70.99.223.143]:4060 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab0JKHSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 03:18:46 -0400
Message-ID: <4CB2BA3F.4040208@canonical.com>
Date: Mon, 11 Oct 2010 08:18:23 +0100
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Anisse Astier <anisse@astier.eu>, Eric Anholt <eric@anholt.net>,
        Kees Cook <kees@canonical.com>
Subject: Re: [Bug #16891] Kernel panic while loading intel module during boot
References: <pyPtebg28EI.A.ZPH.NvgsMB@chimera> <yeAD7A8RDxC.A.u6H.KwgsMB@chimera>
In-Reply-To: <yeAD7A8RDxC.A.u6H.KwgsMB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2010 08:18 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16891
> Subject		: Kernel panic while loading intel module during boot
> Submitter	: Anisse Astier<anisse@astier.eu>
> Date		: 2010-08-24 13:19 (48 days old)
>
>

The original respondent (Kees Cook) assures me that the patch in 
https://bugzilla.kernel.org/attachment.cgi?id=32602&action=edit does not 
regress his platform.

Comment added to the bug report.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
