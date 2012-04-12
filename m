Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576Ab2DLBNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:13:20 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:34816 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296Ab2DLBNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:13:18 -0400
Date: Wed, 11 Apr 2012 18:13:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Sergio Correia <lists@uece.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120412011313.GA23764@kroah.com>
References: <20120411231102.GA6404@kroah.com>
 <CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com>
 <20120412002927.GA23167@kroah.com>
 <CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 04:03:59AM +0300, Felipe Contreras wrote:
> On Thu, Apr 12, 2012 at 3:29 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Wed, Apr 11, 2012 at 07:59:14PM -0400, Sergio Correia wrote:
> >> Hello Greg,
> >>
> >>
> >> On Wed, Apr 11, 2012 at 7:11 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> > This is the start of the stable review cycle for the 3.3.2 release.
> >> > There are 78 patches in this series, all will be posted as a response
> >> > to this one.  If anyone has any issues with these being applied, please
> >> > let me know.
> >> >
> >> > Responses should be made by Fri Apr 13 23:10:16 UTC 2012.
> >> > Anything received after that time might be too late.
> >> >
> >>
> >> is there any chance for this one to be included in this review cycle?
> >>
> >> http://www.spinics.net/lists/linux-wireless/msg87999.html
> 
> I was going to ask for exactly the same thing. My system is completely
> unusable without this patch; not only does the network doesn't work,
> but quite often the kernel is stuck consuming 100% of the CPU.
> 
> > Have you read Documentation/stable_kernel_rules.txt?  Based on that, I
> > don't think it can, yet, right?
> 
> Why not? This patch makes the code go back to a previous state, it is
> obviously more stable than the current state, and the code already
> exists in Linus's tree (in previous releases).

It does?  What is the git commit id of the patch?  Based in the email
above, I assumed it had not made it to Linus's tree already.

> But hey, I guess it's OK that 3.3.x is stuck in and endless loop right
> after booting, because rules are more important than fixing obvious
> breakage.

What rule did you think I was saying this was not acceptable for?

greg k-h
