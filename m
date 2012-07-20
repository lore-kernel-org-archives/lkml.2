Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab2GTSet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:34:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36882 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab2GTSes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:34:48 -0400
Message-ID: <1342805139.2583.46.camel@twins>
Subject: Re: [ 11/37] sched/nohz: Rewrite and fix load-avg computation --
 again
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@kernel.org>,
        Doug Smythies <dsmythies@telus.net>
Date: Fri, 20 Jul 2012 19:25:39 +0200
In-Reply-To: <20120720171313.GC2885@burratino>
References: <20120717232455.GA5994@kroah.com>
	 <20120717232431.399005532@linuxfoundation.org>
	 <20120717232432.250519502@linuxfoundation.org>
	 <20120718001607.GJ25325@burratino> <1342803898.2583.32.camel@twins>
	 <20120720171313.GC2885@burratino>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 12:13 -0500, Jonathan Nieder wrote:
> Peter Zijlstra wrote:
> > On Tue, 2012-07-17 at 19:16 -0500, Jonathan Nieder wrote:
> 
> >> I'm thrilled to see this regression fix for stable@, but are we really
> >> really sure that it won't cause new regressions? 
> >
> > Doug Smythies ran a ~68 hour test on it, running various synthetic loads
> > of various frequencies against it and comparing the reported load
> > averages against the expected values and found it to be 'good'.
> >
> > This doesn't guarantee we won't find more 'interesting' problems in
> > there, but it does give me fair confidence in it.
> 
> Yeah, that sounds good.  Very nice to hear.
> 
> Is the code to generate the synthetic loads and expected results
> somewhere easy to find (like LTP or tools/testing) to make it easier
> to keep this code working well in the future?

/me finds Doug isn't actually on the CC, /me fixes.

Doug had this web-page with all his testing activities, graphs and code
etc..

  http://www.smythies.com/~doug/network/load_average/

Seems to still work.

Last time I tried his scripts they weren't very user friendly, and afaik
he's making the pretty graphs 'manually'. But whatever he's got is there
I think.

If someone wants to take it and make it pretty and 'usable' for people
in a hurry I'm sure Doug wouldn't mind.
