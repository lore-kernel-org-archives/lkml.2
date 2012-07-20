Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab2GTRNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:13:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47953 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab2GTRNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:13:22 -0400
Date: Fri, 20 Jul 2012 12:13:14 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@kernel.org>
Subject: Re: [ 11/37] sched/nohz: Rewrite and fix load-avg computation --
 again
Message-ID: <20120720171313.GC2885@burratino>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
 <20120717232432.250519502@linuxfoundation.org>
 <20120718001607.GJ25325@burratino>
 <1342803898.2583.32.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342803898.2583.32.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2012-07-17 at 19:16 -0500, Jonathan Nieder wrote:

>> I'm thrilled to see this regression fix for stable@, but are we really
>> really sure that it won't cause new regressions? 
>
> Doug Smythies ran a ~68 hour test on it, running various synthetic loads
> of various frequencies against it and comparing the reported load
> averages against the expected values and found it to be 'good'.
>
> This doesn't guarantee we won't find more 'interesting' problems in
> there, but it does give me fair confidence in it.

Yeah, that sounds good.  Very nice to hear.

Is the code to generate the synthetic loads and expected results
somewhere easy to find (like LTP or tools/testing) to make it easier
to keep this code working well in the future?

Grateful,
Jonathan
