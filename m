Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab0FNPVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:21:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53985 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab0FNPVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:21:32 -0400
Message-ID: <4C1648AD.5020607@zytor.com>
Date: Mon, 14 Jun 2010 08:20:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Borislav Petkov <bp@amd64.org>,
       Borislav Petkov <bp@alien8.de>,
       "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, hweight: Fix UML boot crash
References: <201005271944.09541.toralf.foerster@gmx.de> <201006141544.59500.toralf.foerster@gmx.de> <AANLkTik7aQPVl2OsOIhAtMzRHDNw6jkZYzcRNtfi7QSh@mail.gmail.com> <201006141711.26975.toralf.foerster@gmx.de>
In-Reply-To: <201006141711.26975.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 08:11 AM, Toralf Förster wrote:
> 
> Geert Uytterhoeven wrote at 16:39:00
>> I assume you did a `make clean' in between?
> ...
>> BTW, I'm also using ccache. Always. Ever. All my (cross)compilers are
> Well, I'm unsure - might be I made that mistake, especially b/c I use ccache 
> too since years and didn't experienced any fault so far.

I have certainly seen a number of cases where ccache doesn't pick up
sublte differences, for reasons unknown.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

