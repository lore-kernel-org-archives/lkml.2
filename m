Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab2AUNsa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 08:48:30 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38628 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730Ab2AUNsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 08:48:24 -0500
X-Sasl-enc: AjhdUomjnO/4JCv4uoB4MPVZCeCehOhC0ueCaE42QUZk 1327153704
Date: Sat, 21 Jan 2012 08:47:06 -0500
From: Greg KH <greg@kroah.com>
To: Willy Tarreau <w@1wt.eu>
Cc: tim.gardner@canonical.com, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Latest kernel stable/longterm status
Message-ID: <20120121134706.GA21515@kroah.com>
References: <20120110003705.GA9482@kroah.com>
 <20120110022617.GA11376@home.goodmis.org>
 <4F0C0CF5.1080706@gmail.com>
 <20120110235612.GB1507@kroah.com>
 <4F0D6006.40506@canonical.com>
 <20120111151218.GB24077@kroah.com>
 <4F0DF2F3.8080902@canonical.com>
 <20120111205212.GA18902@kroah.com>
 <20120121133620.GA10602@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120121133620.GA10602@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 02:36:20PM +0100, Willy Tarreau wrote:
> Hi Greg,
> 
> On Wed, Jan 11, 2012 at 12:52:12PM -0800, Greg KH wrote:
> > On Wed, Jan 11, 2012 at 09:37:07PM +0100, Tim Gardner wrote:
> > > On 01/11/2012 04:12 PM, Greg KH wrote:
> > > >
> > > >As I previously stated, in this email, I already have someone lined up
> > > >to maintain 2.6.32 after I am done with it, but I'm sure that person
> > > >would love it if you would send any needed patches to
> > > >stable@vger.kernel.org to help them out.
> > > >
> > > >greg k-h
> > > 
> > > I'm happy to work with whomever. Your original email with "it might
> > > be picked up by someone else, but I'm not going to promise anything"
> > > didn't seem that definite.
> > 
> > Sorry, I didn't want to put words in the mouth of someone else, but
> > given that Willy has done a great job with 2.4 and 2.6.16, I'm pretty
> > sure he will continue to do well with 2.6.32.
> 
> Thanks for the nice comment :-) Please note that I did not work on
> 2.6.16, Adrian did, I only worked on .20 and .27.

Ah, you are right, sorry about that, too many different trees :)

But also note that Adrian didn't really follow the "stable rules", so I
don't count that as proper maintaining of that tree.

> Yes I'm still interested in taking over 2.6.32 when you give it up. I
> must admit I've got quite silent last months, slowly trying to find time
> to backport 2.6.32 fixes into .27, and still a bit afraid by the added
> complexity of the new publication model. Time will tell. This weel-end
> I hope to be able to produce 2.6.27.60-rc1.
> 
> What is very important to me is that I want people to complain if they
> find that I'm too slow, as I don't want to degrade the quality of the
> stable series by taking a position someone would take better.

I don't think you will do a bad job at all, You'll do fine, if you need
any help, feel free to ask.

thanks,

greg k-h
