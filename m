Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934225Ab1CXUkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:40:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58278 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab1CXUk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:40:29 -0400
Date: Thu, 24 Mar 2011 20:40:26 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Subject: Re: [RFC PATCHv2 4/4] drivers/otp: convert bfin otp to generic OTP
Message-ID: <20110324204026.GM3130@pulham.picochip.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <1300980071-24645-5-git-send-email-jamie@jamieiles.com>
 <AANLkTikzoNDaaz+4MAb7WzQ09+A4=7r=gpdt0ojc3Q2G@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikzoNDaaz+4MAb7WzQ09+A4=7r=gpdt0ojc3Q2G@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 02:52:20PM -0400, Mike Frysinger wrote:
> On Thu, Mar 24, 2011 at 11:21, Jamie Iles wrote:
> > +config BFIN_OTP_WRITE_ENABLE
> > +       bool "Enable writing support of OTP pages"
> > +       depends on BFIN_OTP
> > +       default n
> > +       help
> > +         If you say Y here, you will enable support for writing of the
> > +         OTP pages.  This is dangerous by nature as you can only program
> > +         the pages once, so only enable this option when you actually
> > +         need it so as to not inadvertently clobber data.
> 
> if the generic layer is providing write enable access now, is this
> still necessary ?  we could have a common OTP Kconfig i think for
> "enable OTP write support".

Sounds like a good idea.  I'll integrate this into the next revision.

Jamie
