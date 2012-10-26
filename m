Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934158Ab2JZVke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 17:40:34 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:4663 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933923Ab2JZVkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 17:40:31 -0400
Message-ID: <1351287624.6885.4.camel@lorien2>
Subject: Re: [PATCH RFT RESEND linux-next] sparc: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: David Miller <davem@davemloft.net>
Cc: kyungmin.park@samsung.com, arnd@arndb.de, m.szyprowski@samsung.com,
        sam@ravnborg.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Date: Fri, 26 Oct 2012 15:40:24 -0600
In-Reply-To: <20121026.151055.328093458246032481.davem@davemloft.net>
References: <1351211909.6851.26.camel@lorien2>
	 <1351267989.4013.20.camel@lorien2>
	 <20121026.150153.1335892148865957561.davem@davemloft.net>
	 <20121026.151055.328093458246032481.davem@davemloft.net>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 15:10 -0400, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Fri, 26 Oct 2012 15:01:53 -0400 (EDT)
> 
> > From: Shuah Khan <shuah.khan@hp.com>
> > Date: Fri, 26 Oct 2012 10:13:09 -0600
> > 
> >> Add support for debug_dma_mapping_error() call to avoid warning from
> >> debug_dma_unmap() interface when it checks for mapping error checked
> >> status. Without this patch, device driver failed to check map error
> >> warning is generated.
> >> 
> >> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> > 
> > Why are you resending this?
> > 
> > When you resend patches, you have to give a reason.  Did the patch
> > change?  Are you updating the CC: list of the patch posting? Are
> > you correcting something else?
> 
> In fact you sent this _3_ times.  Please, don't do this, or at least
> explain why you are reposting something each time.

I am really sorry for the noise. I forgot to mark this explicitly for
linux-next the first time and this patch depends on a patch that went
into linux-next. I sent a few patches for several architectures and lost
track. I meant to add explanation before I hit send. The reason for
resend is to tag it for linux-next. 

-- Shuah


