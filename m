Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301Ab2CWTLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:11:01 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:47974 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109Ab2CWTK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:10:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120323162051.GA20834@kroah.com>
References: <CAEwYmTJzzUi1qfRHYfZg77g1K7myNsAh2oDiY7hWxzRO5hQGHA@mail.gmail.com>
	<20120322212816.GB30888@kroah.com>
	<CAEwYmT+K7qr94D+ef1hgG1A2u0a9z+sopBjm08N2DcxM1FrM1w@mail.gmail.com>
	<20120323162051.GA20834@kroah.com>
Date: Fri, 23 Mar 2012 15:10:56 -0400
Message-ID: <CAEwYmTKiC4TcKe=KN4FD_aNAWuoK6HOPCuttbnk-8he5+Dj+Qw@mail.gmail.com>
Subject: Re: sysfs binary attribute API flux
From: Jonathan McCune <jonmccune@cmu.edu>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_600_699 0, BODY_SIZE_7000_LESS 0, FROM_EDU_TLD 0, WEBMAIL_SOURCE 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HELO_GMAIL 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __PHISH_SPEAR_HTTP_RECEIVED 0, __PHISH_SPEAR_STRUCTURE_1 0, __PHISH_SPEAR_STRUCTURE_2 0, __RDNS_GMAIL 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 12:20 PM, Greg KH <greg@kroah.com> wrote:
> No kernel api is stable, nor will it ever be, see
> Documentation/stable_api_nonsense.txt for details.  As your code is
> living outside of the main kernel.org tree, you will have to deal with
> this for any number of different function calls you make, sysfs is not
> unique at all here.

Thank you.  I think this puts the issue to rest for me.

> Why not just create a new syscall for your work?  That would be easier
> in the longrun, and really, that is what you are doing here.

I may do just that.

Thanks,
-Jon
