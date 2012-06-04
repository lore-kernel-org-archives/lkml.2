Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652Ab2FDN4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:56:36 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45764 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752641Ab2FDN4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:56:35 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+G7zwWZGCG+0fOxyxUoPaPi6kyWjv8bMOCsrSQSM
	NRpbKakFAGLiIr
Message-ID: <4FCCBE8F.6020707@gmx.de>
Date: Mon, 04 Jun 2012 15:56:31 +0200
From: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120603 Thunderbird/12.0.1
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: user-mode-linux-user@lists.sourceforge.net,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-v3.5-rc1: start of a user mode linux produces a core file
References: <4FCB2FDC.1080509@gmx.de> <CAFLxGvwn+SDRy7-FuOwuoKYqDCPjrPA=8HQ7r+kqxe9Zk5R_hA@mail.gmail.com>
In-Reply-To: <CAFLxGvwn+SDRy7-FuOwuoKYqDCPjrPA=8HQ7r+kqxe9Zk5R_hA@mail.gmail.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2012 11:41 AM, richard -rw- weinberger wrote:
> Al and I currently working on -rc1.
> There are TTY and signal issues.
> 
> Stay tuned.
> 
Yep - there's something wired. The current git version cannot be started
in background, meaning that something like
$>./linux ... con=pts con0=fd:0,fd:1 con1=pts con12=pts ... &

creates 3 processes called "linux" - and the output doesn't continue after :

...
NET: Registered protocol family 17
Key type dns_resolver registered
initlevel:7=late, 21 registered initcalls
Initialized stdio console driver




-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
