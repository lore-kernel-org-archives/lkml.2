Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab2JVPQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:16:14 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:34651 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754809Ab2JVPQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:16:05 -0400
Message-ID: <50856331.8070403@xenotime.net>
Date: Mon, 22 Oct 2012 08:16:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Compilation options
References: <op.wmkol7qy6426ze@localhost.localdomain>
In-Reply-To: <op.wmkol7qy6426ze@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 01:59 AM, Uwaysi Bin Kareem wrote:

> Hiya, I compiled the kernel with V=1 and noticed "-mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx". Is there a way to turn this on? Alt, in what file is this string, so I can try without it.


Please teach your mail program to wrap lines around column 70-72.  thanks.


That string is located in arch/x86/Makefile:

# prevent gcc from generating any FP code by mistake
KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
KBUILD_CFLAGS += $(call cc-option,-mno-avx,)


-- 
~Randy
