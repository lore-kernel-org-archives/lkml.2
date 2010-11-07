Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab0KGFo3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 01:44:29 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51624 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab0KGFo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 01:44:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q4p/YSYpCV2gMYvNuyhONjPXjKbq8tNN8VoojjhPaKxUtr2EaswN7zsOCopqUcf3h2
         OIuE5s54QqI6QP0hJJjl5hiL7qpoyEXht8cRJuVPr3sApaefAZTfx6JeDEyObBW2qbkY
         g25B3lHDe7KwdE871nFQooRiisyEly5dXKweQ=
Date: Sat, 6 Nov 2010 22:44:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tracey Dent <tdent48227@gmail.com>
Cc: jkosina@suse.cz, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        spbnick@gmail.com, chatty@enac.fr
Subject: Re: [PATCH 1/2] Drivers: hid: Makefile: Cleaned up Makefile
Message-ID: <20101107054420.GA3823@core.coreip.homeip.net>
References: <1289070464-3392-1-git-send-email-tdent48227@gmail.com>
 <20101106195705.GA26765@core.coreip.homeip.net>
 <AANLkTikYLn3TQdKFd-Du33y5tuXhX08P1TYcJG0eCbtJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikYLn3TQdKFd-Du33y5tuXhX08P1TYcJG0eCbtJ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 04:51:05PM -0400, Tracey Dent wrote:
> On 11/6/10, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > Hi Tracey,
> >
> > On Sat, Nov 06, 2010 at 03:07:43PM -0400, Tracey Dent wrote:
> >> Changed Makefile to use <modules>-y instead of <modules>-objs.
> >>
> >
> > Changelog normally should say why something has been done as what has
> > been done is pretty clear from the patch itself.
> >
> 
> Do you want me to resend patch with more descriptive changelog?
> 

Yes please.

-- 
Dmitry
