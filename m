Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038Ab2LIPHZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 10:07:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305Ab2LIPHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 10:07:23 -0500
Message-ID: <50C4A928.1010803@suse.cz>
Date: Sun, 09 Dec 2012 16:07:20 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Arnaud Lacombe <lacombar@gmail.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Richard Weinberger <richard@nod.at>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: Unbreak cleaning external module build directory
References: <50A8F837.7040700@acm.org>
In-Reply-To: <50A8F837.7040700@acm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.11.2012 16:01, Bart Van Assche wrote:
> Avoid that "$(MAKE) -C $(KDIR) M=$(PWD) clean" triggers the following
> error message when invoked from inside the Makefile of an external
> kernel module:
> 
> rm: cannot remove 'System.map': Permission denied
> make[1]: *** [clean] Error 1

I just applied an earlier patch to fix this:
https://patchwork.kernel.org/patch/1663011/

Michal

