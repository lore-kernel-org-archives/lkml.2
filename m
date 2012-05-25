Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab2EYUfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:35:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43449 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682Ab2EYUfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:35:18 -0400
Message-ID: <4FBFEC74.7090602@zytor.com>
Date: Fri, 25 May 2012 13:32:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Sam Ravnborg <sam@ravnborg.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/4] [-next] Makefile: Do not call cc-option before including
 the arch's Makefile
References: <1336855148-18817-1-git-send-email-geert@linux-m68k.org> <20120520092744.GA21341@merkur.ravnborg.org> <4FBF7B34.2080506@suse.cz>
In-Reply-To: <4FBF7B34.2080506@suse.cz>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 05:29 AM, Michal Marek wrote:
>>
>> Michal - was this serie ever applied to kbuild?
> 
> The first patch has to go to the tip tree, where the CONFIG_READABLE_ASM
> option is introduced. The remaining patches can go to the individual
> arch trees, I see Geert already pushed the m68k one.
> 

OK, can you ack it, please?

	-hpa

