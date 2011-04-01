Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab1DAUir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 16:38:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37631 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751000Ab1DAUiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 16:38:46 -0400
Date: Fri, 1 Apr 2011 21:39:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Charles Samuels <charles@cariden.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Queuing of disk writes
Message-ID: <20110401213917.1bebfa5f@lxorguk.ukuu.org.uk>
In-Reply-To: <201104011334.24182.charles@cariden.com>
References: <201104011259.53936.charles@cariden.com>
	<20110401211049.6c183cfc@lxorguk.ukuu.org.uk>
	<201104011334.24182.charles@cariden.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've seen this on ext3, ext4, and XFS. Reiser3 not so much. I've also 
> convinced my users to use write-backed cache. They're Enterprise customers and 
> have loads of money to spend on hardware, such as Warp Cores.

ext3 certainly suffers badly from it, that is known.

> > The ultima answer is probably an SSD of course 8)
> Well, that would solve the throughput, but it doesn't solve the blocking!

Best place to go might be linux-fsdevel - especially if you can generate
a simulation of the problem workload (ie one that just does the I/O
patterns)

