Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2IGRzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:55:43 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46622 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2IGRzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:55:40 -0400
Message-ID: <504A3527.9070104@gmail.com>
Date: Fri, 07 Sep 2012 19:55:51 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120826 Thunderbird/14.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 3.6-rc4
References: <CA+55aFzJWwBPgqp_QquhncpRqLXHRh0m9hHPh94Ujzd1d7kMDQ@mail.gmail.com> <20120904154412.GA14321@redhat.com>
In-Reply-To: <20120904154412.GA14321@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 05:44 PM, Dave Jones wrote:
> On Sat, Sep 01, 2012 at 03:10:58PM -0700, Linus Torvalds wrote:
>  > The kernel summit is over, and most people have either returned or are
>  > returning from San Diego.
> 
> Still seeing this, that I started seeing just before leaving for San Diego..
> 
> 	Dave

I've bisected this one down to


d35abdb28824cf74f0a106a0f9c6f3ff700a35bf is the first bad commit
commit d35abdb28824cf74f0a106a0f9c6f3ff700a35bf
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Jun 30 11:55:24 2012 +0400

    hold task_lock around checks in keyctl

    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>


Just didn't get a response from anyone when I've mailed about it...
