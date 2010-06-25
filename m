Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab0FYOCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 10:02:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49290 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776Ab0FYOCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 10:02:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [linux-pm] [PATCH 1/9] PM / Hibernate: swap, 
 =?iso-8859-1?q?=09switch_to?= hibernate_io_handle
Date: Fri, 25 Jun 2010 16:00:37 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz> <4C1F8366.70306@gmail.com> <4C1FE09B.9040703@crca.org.au>
In-Reply-To: <4C1FE09B.9040703@crca.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006251600.37455.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 21, 2010, Nigel Cunningham wrote:
> Hi Jiri.
> 
> On 22/06/10 01:21, Jiri Slaby wrote:
> > On 06/11/2010 11:46 AM, Nigel Cunningham wrote:
> >> On 02/06/10 18:52, Jiri Slaby wrote:
> >>> I addressed the comments I got on the previous RFC. I left the handles
> >>> in place, the functions in hibernate_io_ops now works on them. Further
> >>> I got rid of the memory barriers and minimized global variables as much
> >>> as possible. Comments welcome.
> >>
> >> I would like to hear the arguments for using these handles. I understand
> >> there may have been some previous discussion, but am unable to find it.
> >>
> >> It seems far more sensible to me to not pass around a handle that
> >> virtually nothing actually uses, and instead store and utilise the state
> >> in the place where it is actually useful. If we had more than one struct
> >> hibernate_io_handle in use at a time, I could understand going this way.
> >> As it stands, however...
> >
> > Hi, it I added that based on this: http://lkml.org/lkml/2010/3/24/458
> 
> Okay; thanks.
> 
> Looking at Pavel's comment is confusing. The variable you were adding 
> isn't "global static" (that's a contradiction in terms anyway). Its 
> scope is the file level.
> 
> Since the data is only used in this file, your change makes perfect 
> sense to me.
> 
> Rafael, Pavel: care to discuss this further?

Well.  Generally speaking, I like things as they are, except for patches [3/9]
and [4/9].

So, I'd like to take [1-2/9] and [5-9/9].  Jiri, do [6-7/9] need to be changed
substantially in case [3-4/9] are dropped?

Rafael
