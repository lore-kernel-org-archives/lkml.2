Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab1CPLyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 07:54:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60554 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751437Ab1CPLyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 07:54:36 -0400
Date: Wed, 16 Mar 2011 11:54:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: snmp snmp <snmp.ml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Query
Message-ID: <20110316115439.6e036e75@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTimP9-SK3YCwgsS8USEYNExFQTQLPYXKi+RUbBT4@mail.gmail.com>
References: <AANLkTimP9-SK3YCwgsS8USEYNExFQTQLPYXKi+RUbBT4@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>      Me and my friends are working on a new concept.

It's not really new. Various systems have done this historically, and
folks including Larry McVoy have proposed that for large scalability you
might build a system out of multiple separate kernels one on each NUMA
node and which had interfaces to loan or share pages with one another by
bumping page counts and handling coherency.

Cool to see someone trying some of this in Linux

>      Our implementation is on Intel core 2 duo machine. So far our
> implementation includes running two kernels simultaneously (one on
> each core) , handling hard-disk on one core and ethernet on another
> core so as to divide the network and disk subsystem.
> 
>      But here we are unable to measure the performance. Can u please
> suggest any method to measure the performance in terms of throughput
> and response time?

There are a bunch of standard benchmarks you can use. A lot of the big
name ones need clusters of systems to do the loading but there are things
like dbench that are quite useful on single systems.

For some of the applications you are talking about I think dbench might
be a good start.


Alan
