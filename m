Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab1KLBNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 20:13:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36396 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab1KLBNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 20:13:32 -0500
Date: Fri, 11 Nov 2011 19:13:28 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: "John 'Warthog9' Hawley" <warthog9@kernel.org>
Cc: webmaster@kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Is a dump of the old bugzilla.kernel.org available?
Message-ID: <20111112011328.GB6602@elie.hsd1.il.comcast.net>
References: <20111111231747.GA6025@elie.hsd1.il.comcast.net>
 <4EBDBBE6.9020306@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBDBBE6.9020306@kernel.org>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John 'Warthog9' Hawley wrote:

> It's not back up for a number of reasons, the biggest is that the
> hardware that needs to be in place to get the dynamic web stuff from
> kernel.org (wikis, bugzilla, kernel oops, etc) up and running, isn't in
> place yet.  Right now I don't have an absolutely solid ETA on that, but
> I will try and let people know once I do.
>
> I've gotten the wikis up in a read-only form, but I don't have so easy a
> way to do that with bugzilla.

Thanks.  

The only ways I know of to mine data from a bugzilla instance are to
make a database dump[1] or to use the XML that the CGI scripts spit
out[2].  So I fear I can't help much.

[1] https://wiki.mozilla.org/Bugzilla:Move_Installation
[2] e.g., http://www.roundup-tracker.org/cgi-bin/moin.cgi/ImportingFromBugzilla
