Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab1A1MFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 07:05:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60411 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab1A1MFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 07:05:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH V10 01/15] time: Introduce timekeeping_inject_offset
Date: Fri, 28 Jan 2011 13:05:37 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
References: <cover.1296124770.git.richard.cochran@omicron.at> <1296154099.2855.162.camel@work-vm> <20110128070800.GA3225@riccoc20.at.omicron.at>
In-Reply-To: <20110128070800.GA3225@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101281305.37370.arnd@arndb.de>
X-Provags-ID: V02:K0:xbxgjlLB/lDt5BMiXsGFirgI5fB+0yNdcv+yodAQgrD
 b/rQU9PjJDEe8fkVBpliZGuJRIfDdnDv2gTXI17pYRl7anN3D4
 wK4UhuiQPMaux1IIzt94mmFBPMUxOuoYSpsxSCVLf4vrR82FvE
 VfatGMjZ1Sv/YtWIJ8hrHpjRuQC/tzqBgKDNE9krLpgBfWB0Nn
 Q6Y4z/ZaaVFieb5Qp+B+Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 January 2011, Richard Cochran wrote:
> I would like to get to the bottom of this. Here is what I did:
> 
>    1. Saved your patch to disk in mbox format using Mutt.
>    2. git am
>    3. ... rebase, rebase, rebase, ...
>    4. git format-patch [options] 1234..abcd
>    5. Edit cover letter
>    6. for x in 00*; do mutt -H $x; done
> 
> Git format-patch places the "From: John Stultz <john.stultz@linaro.org>"
> line with the other mail headers, and so I guess mutt just faithfully
> preserves this.
> 
> I don't like having to remember to fix this manually. There must be a
> better way...

The problem is step 6. The output of git format-patch does not work when
sending with mutt. The easiest solution is to send with git send-email,
which does the same as mutt -H, but gets it right.

	Arnd
