Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab0FJG21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 02:28:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54088 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab0FJG20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 02:28:26 -0400
Message-ID: <4C108587.6070409@zytor.com>
Date: Wed, 09 Jun 2010 23:26:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, jdike@addtoit.com, bharrosh@panasas.com,
       bp@alien8.de, akpm@linux-foundation.org, toralf.foerster@gmx.de,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, hweight: Fix UML boot crash
References: <201005271944.09541.toralf.foerster@gmx.de>	<20100530170346.GC1565@liondog.tnic>	<tip-cc7f0a7b3004a4ca0bfef0e1ca79f2e0da6ca1b0@git.kernel.org>	<4C1018FD.8090109@linux.intel.com> <AANLkTil3rzSvLnxTerj_FxaCLpdokL5BB5z8QOcL7dbr@mail.gmail.com>
In-Reply-To: <AANLkTil3rzSvLnxTerj_FxaCLpdokL5BB5z8QOcL7dbr@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2010 10:32 PM, Geert Uytterhoeven wrote:
> On Thu, Jun 10, 2010 at 00:43, H. Peter Anvin <hpa@linux.intel.com> wrote:
>> Note: I have applied this  because it fixes a regression, but it bugs
> 
> You seem to have pushed the wrong one, from this/the old thread (new one has
> `resent' in the subject)?
> 

I tried to make sure I wouldn't get bad metadata, and found that the
newer patch was supposedly marked "doesn't work".

If it was a build dependency issue that is one thing.  I'll replace the
patch tomorrow.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

