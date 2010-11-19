Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab0KSCcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 21:32:12 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52740 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab0KSCcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 21:32:11 -0500
Content-Type: text/plain; charset=UTF-8
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Ian Munsie <imunsie@au1.ibm.com>
To: Jason Baron <jbaron@redhat.com>
In-reply-to: <20101118151141.GA3368@redhat.com>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6> <1290041086-sup-5766@au1.ibm.com> <20101118151141.GA3368@redhat.com>
Date: Fri, 19 Nov 2010 13:32:08 +1100
Message-Id: <1290133618-sup-2278@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

I'm adding Avantika to the CC list as she recently contacted me
regarding syscall tracepoints on PowerPC.

Excerpts from Jason Baron's message of Fri Nov 19 02:11:42 +1100 2010:
> I was wondering what the status of those patches were...last I remember
> they looked pretty good to me...I'd be more than happy to help review
> those.

Yeah there isn't much left to do on them - the main delay has just been
finding some time to work on them.

I did want to revisit the naming of the events and the subtle
differences for syscalls with a single implementation for both the
native and compat versions versus those that have separate
implementations - I don't want userspace to have to care about that
distinction.

I recall there were a few comments on some of your patches in the series
- if I rebase the patches on the current tip tree and publish the tree
somewhere would you be willing to take a look at those?


Cheers,
-Ian
