Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab1CBFrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 00:47:43 -0500
Received: from kroah.org ([198.145.64.141]:35705 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab1CBFrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 00:47:41 -0500
Date: Wed, 2 Mar 2011 00:42:49 -0500
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 6/6] Staging: hv: Cleanup hyperv_driver variable names
Message-ID: <20110302054249.GC28382@kroah.com>
References: <1298686078-30945-1-git-send-email-kys@microsoft.com>
 <20110301025859.GG1663@kroah.com>
 <6E21E5352C11B742B20C142EB499E048016633@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048016633@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 01:44:11AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Monday, February 28, 2011 9:59 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang; Hank
> > Janssen
> > Subject: Re: [PATCH 6/6] Staging: hv: Cleanup hyperv_driver variable names
> > 
> > On Fri, Feb 25, 2011 at 06:07:58PM -0800, K. Y. Srinivasan wrote:
> > > The title says it all.
> > 
> > That's a horrible changelog comment.  So bad that I would rather see an
> > empty message than this one.  Seriously, it give no description, and
> > makes us think that the whole patch is obvious, when it really isn't.
> > 
> > What did you change them to?
> > What did you change them from?
> > What was your motivation in changing them?
> > How were you feeling when the names changed?
> > 
> > Ok, maybe not the last one, but you get the idea.
> 
> Greg, these changes (patches 1 through 6) change so much in this
> sub-system that until these changes go in, our cleanup efforts are
> stalled.

Ok, but that's not my issue, it's yours :)

And what's the rush?

> That is the main reason I was so hasty in submitting these patches.
> Clearly, I need to provide a better changelog comment; and I will.
> Looking at your other comments, I am wondering if the granularity I
> chose for breaking up the changes that had to be done  is also a
> significant part of the problem. If it is ok with you, I could
> generate a  patch that deals with all device related issues and a
> patch that deals with all driver related issues. These patches
> obviously will  do more than one thing (however they will all be
> related); but at least they won't have intermediate state that would
> be objectionable. Let me know.

Ick, no, you need to break these up into smaller pieces than just the 6
you did here, as you were still doing more than one thing per patch.

Please make them simpler, not more complex.

thanks,

greg k-h
