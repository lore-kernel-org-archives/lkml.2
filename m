Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab2DIIVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:21:08 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58041 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754870Ab2DIIVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:21:06 -0400
Date: Mon, 9 Apr 2012 11:20:57 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Anton Vorontsov <anton.vorontsov@linaro.org>
cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 2/3] vmevent-test: No need for SDL library
In-Reply-To: <20120408233820.GB4839@panacea>
Message-ID: <alpine.LFD.2.02.1204091120490.6479@tux.localdomain>
References: <20120408233550.GA3791@panacea> <20120408233820.GB4839@panacea>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2012, Anton Vorontsov wrote:
> panacea:~/src/linux/linux-vmevent/tools/testing/vmevent$ make
> cc -O3 -g -std=gnu99 -Wcast-align -Wformat -Wformat-security
> -Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls
> -Wstrict-aliasing=3 -Wswitch-default -Wno-system-headers -Wundef
> -Wwrite-strings -Wbad-function-cast -Wmissing-declarations
> -Wmissing-prototypes -Wnested-externs -Wold-style-definition
> -Wstrict-prototypes -Wdeclaration-after-statement  -lSDL  vmevent-test.c
> -o vmevent-test
> /usr/bin/ld: cannot find -lSDL
> collect2: ld returned 1 exit status
> make: *** [vmevent-test] Error 1
> 
> This patch fixes the issue.
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Applied, thanks!
