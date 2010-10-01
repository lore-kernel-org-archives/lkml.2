Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab0JAHT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:19:57 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56260 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0JAHT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:19:56 -0400
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        benh <benh@kernel.crashing.org>, Michal Marek <mmarek@suse.cz>,
        Albert Herranz <albert_herranz@yahoo.es>, paulus <paulus@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 02/18] powerpc: Add CROSSBE_COMPILE to build big endian boot wrapper
From: Ian Munsie <imunsie@au1.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
In-reply-to: <AANLkTi=VmSXN6XeD__nkQLJAYXzxOh6WEtW6-jjJcC4Q@mail.gmail.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com> <1285916771-18033-3-git-send-email-imunsie@au1.ibm.com> <AANLkTi=VmSXN6XeD__nkQLJAYXzxOh6WEtW6-jjJcC4Q@mail.gmail.com>
Date: Fri, 01 Oct 2010 17:19:54 +1000
Message-Id: <1285917531-sup-3488@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Geert Uytterhoeven's message of Fri Oct 01 17:13:19 +1000 2010:
> Shouldn't the help text added by [PATCH 01/18]:
....
> be updated here as well?

Yep, you're right. Thanks for pointing that out, I'll fix it for the next
revision.

Cheers,
-Ian
