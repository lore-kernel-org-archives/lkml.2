Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab2JMOYG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 10:24:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4680 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2JMOYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 10:24:04 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=RHM4pvKubzoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=hedYrj21JNIA:10 a=rIUkz3ZJ4wsveJAefIgA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1350138242.24256.114.camel@gandalf.local.home>
Subject: Re: [PATCH 00/25] asm-generic: Convert all to use Kbuild file
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Date: Sat, 13 Oct 2012 10:24:02 -0400
In-Reply-To: <1762180.8nMW7nCt7B@wuerfel>
References: <20121013022632.024527228@goodmis.org>
	 <1762180.8nMW7nCt7B@wuerfel>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-13 at 09:09 +0000, Arnd Bergmann wrote:

> Note that while you are addressing all the obvious candidates that
> have only a single #include statement in them, there is room to take
> this further because a lot of the other header files in architectures
> are still identical to their asm-generic counterparts (aside from
> whitespace and comments). I would recommend to arch maintainers that
> have not already done so to go through all the headers and replace
> the identical ones with generated headers that include the asm-generic
> version.

I was thinking of doing this as a "take 2", after this set got in.

I'm not sure if it's already there or not, but perhaps checkpatch could
add a way to see if a new file is created in arch/*/include/asm/* that
only adds an include of asm-generic (ignoring the #ifndef _FOO_H
wrappers), and tell the user to use the generic-y += in Kbuild method.

-- Steve


