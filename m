Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab0HGCFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 22:05:44 -0400
Received: from smtp-out.google.com ([74.125.121.35]:21326 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab0HGCFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 22:05:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=lqq2CbOj378XYPYvhfdxJcRWYYEJtfOdiy5f9TLpTJHv0+NNykwTHANN8fWOmcl13
	LYQSoJV4ZuZ7m/p249JqA==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100804195704.GA23681@linux.vnet.ibm.com>
	<20100806225453.GA3947@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
Date: Fri, 6 Aug 2010 19:05:37 -0700
Message-ID: <AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Brian Swetland <swetland@google.com>
To: david@lang.hm
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        tytso@mit.edu, arjan@infradead.org, swmike@swm.pp.se,
        galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 4:59 PM,  <david@lang.hm> wrote:
>
> now, android is betting that the apps are all developed specifically for the
> android from scratch, so having a different API is acceptable, even if it
> cuts them off from the rest of the *nix applications. For a phone this is
> not neccessarily an unreasonable stance, but as Android moves into the
> spaces where normal applications are in use (netbooks and tablets), this
> becomes a much shakier stance to take.

"Normal" apps work reasonably well -- they get halted when the screen
turns off, just like they do when my laptop suspends.

Wakelocks are useful for mobile-centric apps that you want to keep
running in the background, wake up and do work when the device is
"asleep", etc.

Brian
