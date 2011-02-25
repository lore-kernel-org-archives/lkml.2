Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab1BYHxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 02:53:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51349 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab1BYHxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 02:53:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Dnl8Ye5K/oKaesiQyg2frvnMXp79hkQnklJWRqc15B0+0mXzlhN2Vxejz9/ZeoHDtx
         NuDn+NWC4UYj/KfuvflWivw3yId2YZp6JvOFJoCp0w4LuxPko6UVmFLVa79H4OGuGy1u
         avNxnliyGBsanqgMmtiEdKW6HQCZ7bTWDAOU4=
Date: Fri, 25 Feb 2011 08:53:20 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>,
        linux-api@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Paul Mackerras <paulus@samba.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rodolfo Giometti <giometti@linux.it>, Christoph Lameter <cl@linux.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH V11 2/4] ptp: Added a clock that uses the eTSEC found
 on the MPC85xx.
Message-ID: <20110225075320.GA4032@riccoc20.at.omicron.at>
References: <cover.1298447722.git.richard.cochran@omicron.at>
 <be1f5e801e8cd0145dd23aadae7c2055bb3c1d47.1298447722.git.richard.cochran@omicron.at>
 <20110223165058.GE14597@angua.secretlab.ca>
 <20110223112612.30071995@schlenkerla>
 <20110223175459.GH14597@angua.secretlab.ca>
 <20110223132444.65dfdda4@schlenkerla>
 <20110224165004.GB15234@riccoc20.at.omicron.at>
 <20110224112731.2d9bf080@schlenkerla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224112731.2d9bf080@schlenkerla>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 11:27:31AM -0600, Scott Wood wrote:

> My vote, if it goes in a separate node at all, is "fsl,etsec-ptp",

So, that is what the patch does.

> and let the driver use SVR.

What is SVR?

Thanks,
Richard
