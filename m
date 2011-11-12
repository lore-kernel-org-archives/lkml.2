Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab1KLAVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 19:21:03 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42709 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1KLAU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 19:20:59 -0500
Message-ID: <4EBDBBE6.9020306@kernel.org>
Date: Fri, 11 Nov 2011 16:20:54 -0800
From: "John 'Warthog9' Hawley" <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: webmaster@kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Is a dump of the old bugzilla.kernel.org available?
References: <20111111231747.GA6025@elie.hsd1.il.comcast.net>
In-Reply-To: <20111111231747.GA6025@elie.hsd1.il.comcast.net>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 11 Nov 2011 16:20:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2011 03:19 PM, Jonathan Nieder wrote:
> Hi,
> 
> Previously there was a bugzilla instance at
> <http://bugzilla.kernel.org>.  It was handy for reading people's
> reports, and some mailing list threads and patches refer to it.
> 
> I am happy to see people today reporting bugs directly to developers
> through mailing lists instead, which works better, anyway.  So
> reading[1]
> 
> | Rafael said he didn't see a whole lot of value in restoring the
> | bugzilla in its previous form; it would be better to start over with
> | an improved installation.
> 
> worried me a little.  Is there a plan to make the information that was
> previously in bugzilla available in the meantime?  How can interested
> people help?

Bugzilla *WILL* be restored at some point, there are a lot of other
people who use it beyond Rafael.

It's not back up for a number of reasons, the biggest is that the
hardware that needs to be in place to get the dynamic web stuff from
kernel.org (wikis, bugzilla, kernel oops, etc) up and running, isn't in
place yet.  Right now I don't have an absolutely solid ETA on that, but
I will try and let people know once I do.

I've gotten the wikis up in a read-only form, but I don't have so easy a
way to do that with bugzilla.

- John 'Warthog9' Hawley
Chief Kernel.org Administrator
