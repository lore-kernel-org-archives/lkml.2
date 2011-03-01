Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab1CAFqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:46:13 -0500
Received: from kroah.org ([198.145.64.141]:43558 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab1CAFqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:46:09 -0500
Date: Mon, 28 Feb 2011 18:28:39 -0800
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "r@home.goodmis.org" <r@rostedt.homelinux.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 1/6] Staging: hv: Unify hyper-v device abstractions
Message-ID: <20110301022839.GA1663@kroah.com>
References: <1298685930-30806-1-git-send-email-kys@microsoft.com>
 <20110226032122.GA25737@home.goodmis.org>
 <6E21E5352C11B742B20C142EB499E048015786@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048015786@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 05:13:34PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Steven Rostedt [mailto:rostedt@goodmis.org]
> > Sent: Friday, February 25, 2011 10:21 PM
> > To: KY Srinivasan; r@home.goodmis.org
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang; Hank
> > Janssen
> > Subject: Re: [PATCH 1/6] Staging: hv: Unify hyper-v device abstractions
> > 
> > Hi!
> > 
> > Just an FYI,
> > 
> > When sending out patch series, could you send out a [PATCH 0/6] first,
> > and have all other patches a reply to that patch. Both git and quilt
> > have ways to do this.
> 
> My mistake; I numbered the patches 1 through 6 as opposed to 0 through 5.
> Sorry for the confusion.

Wait, what?

So, what should I apply here, only patches 2-6?  What is patch 1 for
then?

still totally confused,

greg k-h
