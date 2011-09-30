Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab1I3DOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 23:14:16 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51646 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754482Ab1I3DOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 23:14:15 -0400
X-Sasl-enc: LLkie92QQ2fY5pIOpk4PLWbmZlye3XZlljPcteRIfdE8 1317352453
Date: Thu, 29 Sep 2011 20:02:57 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 01/24] Staging: hv: mousevsc: Fixup struct
 hv_input_dev_info
Message-ID: <20110930030257.GA10945@kroah.com>
References: <1317322456-9747-1-git-send-email-kys@microsoft.com>
 <1317322504-9788-1-git-send-email-kys@microsoft.com>
 <20110930004739.GA6810@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081EAA5A@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081EAA5A@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 01:34:21AM +0000, KY Srinivasan wrote:
> > From: Greg KH [mailto:greg@kroah.com]
> > <snip>
> > 
> > I only got 21 emails in this thread, and they seemed to trickle in in
> > odd bunches.  Did they all get sent properly, or do you wish to resend
> > them to ensure they all get here?
> 
> I sent them out as I normally send them. I don't know why they are not being 
> delivered as they should be. Given that you have gotten 21 of the 24 patches,
> if you tell me which patches you have not received, I could resend just those.
> Or I could resend the whole series again if you prefer. Let me know.

It looks like they just now went through.  They got stuck on your
server, linuxonhyperv.com if you look at the email headers.  I suggest
you go give that thing a kick to figure out what went wrong.

So don't worry, I got them now...

greg k-h
