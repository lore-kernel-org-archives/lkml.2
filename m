Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab1ESBMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 21:12:33 -0400
Received: from mail.perches.com ([173.55.12.10]:1769 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976Ab1ESBMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 21:12:31 -0400
Subject: Re: [PATCH] staging: brcm80211: brcmfmac: Add and use dhd_dbg
From: Joe Perches <joe@perches.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: Brett Rudley <brudley@broadcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Dowan Kim <dowan@broadcom.com>, Roland Vossen <rvossen@broadcom.com>,
        Arend Van Spriel <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
In-Reply-To: <4DD46865.9010708@broadcom.com>
References: <60c19c2ad4f078b6f283b5ff4ecca3653833ea28.1305742868.git.joe@perches.com>
	 <4DD44C21.1080502@broadcom.com> <1305765163.1745.4.camel@Joe-Laptop>
	 <4DD46865.9010708@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 18:09:41 -0700
Message-ID: <1305767381.1745.8.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 17:46 -0700, Henry Ptasinski wrote:
> On 05/18/2011 05:32 PM, Joe Perches wrote:
> > On Wed, 2011-05-18 at 15:45 -0700, Henry Ptasinski wrote:
> >> On 05/18/2011 11:23 AM, Joe Perches wrote:
> >>> All uses of DHD_<TYPE>   macros are for debugging only.
> >>> Change the multiple uses of DHD_<TYPE>((...)) to dhd_dbg(TYPE, ...)
> >>> for a more consistent style.
> >> I generally like this approach, but in brcmsmac we've been switching to
> >> wiphy_err() and related instead.  Any strong argument for one over the
> >> other?
> > These aren't described as errors but are debugging messages.
> Yes, so wiphy_debug(), wiphy_info(), wiphy_notice(), etc could be used. 

True.  I think debugging messages should not have message levels
promoted without cause.

> > Not all uses use __func__.
> That's just sloppiness on our part.  They should all be consistent.
> > I think __func__ unnecessary and it should be avoided.
> If it's moved into the macro, then there's only one place to change if 
> you want to delete "__func__"/add it back/include it conditionally.
[]
> "brcm_dbg()" seems fine to me.

I'll fix these and resubmit.

