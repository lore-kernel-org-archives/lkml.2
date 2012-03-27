Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2C0DtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 23:49:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34626 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab2C0DtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 23:49:21 -0400
Message-ID: <4F7138B0.8030100@zytor.com>
Date: Mon, 26 Mar 2012 20:49:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
Subject: Re: [PATCH 1/1] vsprintf: optimize decimal conversion (again)
References: <201203262047.17865.vda.linux@googlemail.com> <20120326131304.018a5f4b.akpm@linux-foundation.org> <CAMuHMdWK-0m9-LUc90e7e8pYsOsECkZ3gjBYVAP-A4p7p=Pyug@mail.gmail.com> <201203270118.38639.vda.linux@googlemail.com>
In-Reply-To: <201203270118.38639.vda.linux@googlemail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 04:18 PM, Denys Vlasenko wrote:
> Only 64-bit machines will perform 64-bit
> division, one per 9 decimal digits (thus, at most three divisions
> per one long_long->string conversion).

FWIW, gcc supports 128-bit integers on 64-bit platforms using the
__int128 keyword.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

