Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422657Ab2GMOSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 10:18:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39153 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757674Ab2GMOSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 10:18:35 -0400
Date: Fri, 13 Jul 2012 11:18:29 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [ 000/187] 3.4.5-stable review
Message-ID: <20120713141828.GB3185@herton-Z68MA-D2H-B3>
References: <20120712192421.GA28926@kroah.com>
 <87sjcwz2yb.fsf@turtle.gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sjcwz2yb.fsf@turtle.gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 06:42:52AM +0200, Sven Joachim wrote:
> On 2012-07-12 21:24 +0200, Greg KH wrote:
> 
> > This is the start of the stable review cycle for the 3.4.5 release.
> > There are 187 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> As has been noted already, some of the patches are actually missing.

Yes, the same ones as on 3.0.37 submission:
[ 064/187] ath9k_hw: avoid possible infinite loop in ar9003_get_pll_sqsum_dvc
[ 155/187] PCI: EHCI: fix crash during suspend on ASUS computers
[ 163/187] tracing: change CPU ring buffer state from tracing_cpumask
[ 177/187] mm: Hold a file reference in madvise_remove

Also I couldn't find anywhere in the submission the email for the patch:
"cifs: when server doesn't set CAP_LARGE_READ_X, cap default rsize at MaxBufferSize"
I noted the patch count was off by one, and comparing to the queue git
repo, this one I can't find.

Other thing I had a problem with, is when saving the patches to apply
for testing, some of them were with "charset=y", so I had to fix up
manually, otherwise git am complained.

> 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.5-rc1.gz
> 
> Seems it's not there?
> 
> Cheers,
>        Sven
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
[]'s
Herton
