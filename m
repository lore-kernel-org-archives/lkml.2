Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab0ISCrJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 22:47:09 -0400
Received: from mx1.orcon.net.nz ([219.88.242.51]:56043 "EHLO mx1.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321Ab0ISCrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 22:47:07 -0400
Message-ID: <4C9579A1.5030009@orcon.net.nz>
Date: Sun, 19 Sep 2010 14:46:57 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linux-alpha@vger.kernel.org,
        mattst88@gmail.com
Subject: Re: [PATCH 1/4] alpha: belated ERESTART_RESTARTBLOCK race fix
References: <20100918083846.GA31363@ZenIV.linux.org.uk>
In-Reply-To: <20100918083846.GA31363@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx1.orcon.net.nz on Sun, 19 Sep 2010 14:47:07 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Sep 19 14:47:07 2010
X-DSPAM-Confidence: 0.6091
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/09/10 20:38, Al Viro wrote:
> same thing as had been done on other targets back in 2003 -
> move setting ->restart_block.fn into {rt_,}sigreturn().
>
> Signed-off-by: Al Viro<viro@zeniv.linux.org.uk>

For the patch series:

Tested-by: Michael Cree <mcree@orcon.net.nz>

Cheers
Michael.
