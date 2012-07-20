Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab2GTRFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:05:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:35232 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab2GTRFF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:05:05 -0400
Message-ID: <1342803898.2583.32.camel@twins>
Subject: Re: [ 11/37] sched/nohz: Rewrite and fix load-avg computation --
 again
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@kernel.org>
Date: Fri, 20 Jul 2012 19:04:58 +0200
In-Reply-To: <20120718001607.GJ25325@burratino>
References: <20120717232455.GA5994@kroah.com>
	 <20120717232431.399005532@linuxfoundation.org>
	 <20120717232432.250519502@linuxfoundation.org>
	 <20120718001607.GJ25325@burratino>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 19:16 -0500, Jonathan Nieder wrote:
> I'm thrilled to see this regression fix for stable@, but are we really
> really sure that it won't cause new regressions? 

Doug Smythies ran a ~68 hour test on it, running various synthetic loads
of various frequencies against it and comparing the reported load
averages against the expected values and found it to be 'good'.

This doesn't guarantee we won't find more 'interesting' problems in
there, but it does give me fair confidence in it.
