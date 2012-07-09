Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab2GIOuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:50:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:51572 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab2GIOuC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:50:02 -0400
Message-ID: <1341845396.3462.81.camel@twins>
Subject: Re: perf with precise attribute kills all KVM based VMs
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 09 Jul 2012 16:49:56 +0200
In-Reply-To: <4FFAEF13.7010108@gmail.com>
References: <4FFAE6D8.5050609@gmail.com> <20120709141904.GC7298@redhat.com>
	 <1341843844.3462.75.camel@twins> <4FFAED16.7050204@redhat.com>
	 <4FFAEF13.7010108@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 08:47 -0600, David Ahern wrote:
> 
> I found this testing changes to perf-kvm, but found the problem extends 
> to just perf-record. With perf-record exclude_guest defaults to 1. See 
> tools/perf/util/util.c, event_attr_init(). 

You lost me there.. so perf-record defaults to exclude_guest=1 (which
would make the proposed patch I just send actually possible), but its
still going *bang* ?
