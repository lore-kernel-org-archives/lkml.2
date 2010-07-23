Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab0GWMJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:09:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:33187 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758814Ab0GWMJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:09:35 -0400
Date: Fri, 23 Jul 2010 05:07:47 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Michael Jensen <emjay1988@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: comedidev: Fixed a macro definition
	code style issue
Message-ID: <20100723120747.GC32608@suse.de>
References: <1279865467-16522-1-git-send-email-emjay1988@gmail.com> <4C495880.2090705@gmail.com> <AANLkTi=KTEtA57aTHEd_tzXAmK_WsX+P4jO_3TedFGFk@mail.gmail.com> <4C4970BC.1070901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4970BC.1070901@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 12:36:44PM +0200, Jiri Slaby wrote:
> On 07/23/2010 11:17 AM, Michael Jensen wrote:
> > On Fri, Jul 23, 2010 at 6:53 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> >>
> > <snip>
> >> Hmm, does this compile?
> >>
> > I did build the comedi directory (as per Greg's "Write and submit your
> > first kernel patch" video), and didn't get any errors (once I'd done
> > the configuration)...
> > 
> > Did I miss something?
> 
> Then the macro is probably unused (or unused in your configuration).
> Either way, the macro seems to be intended for use in the top-level
> scope, so do { } while (0) cannot be used there.

I think we might have now removed all users of that macro, so it should
just be deleted.

Michael, can you do that instead of the do/while stuff here, as that is
not a valid change.

thanks,

greg k-h
