Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab0FDN2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 09:28:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab0FDN2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 09:28:32 -0400
Message-ID: <4C08FF7E.8040806@suse.cz>
Date: Fri, 04 Jun 2010 15:28:30 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
Cc: sam@ravnborg.org, agruen@suse.de, linux-kernel@vger.kernel.org
Subject: Re: Makefile.build: make KBUILD_SYMTYPES work again
References: <1274735244-31249-1-git-send-email-dzickus@redhat.com>
In-Reply-To: <1274735244-31249-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.5.2010 23:07, Don Zickus wrote:
> commit 37a8d9f67f18de1e2cbc7387311ce22d4dbff518 tried to combine some
> duplicate code and accidentally broke how KBUILD_SYMTYPES worked
> 
> This fixes the code to match the original intention by the author who
> originally added the code I believe.
> 
> The fixes include:
> - removing extra whitespaces in the if-statements
> - moving the if-statement from around the -r to the -T
> - adding a second arg to cmd_gensymtypes to simplify the options passed
>   to genksyms.
> 
> Tested by instrumenting genksyms and seeing what options were passed in
> during a make, KBUILD_SYMTYPES make, and when a foo.symref was created.
> 
> Everything compiled and looked ok.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>

Thanks. I wrote a very similar patch last year which I thought to have
sent to Sam, but it seems that I haven't (and since then I forgot about
it). Applied now.

Michal
