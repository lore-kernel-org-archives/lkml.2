Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933951Ab2EXRVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:21:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54654 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab2EXRVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:21:17 -0400
Message-ID: <1337880069.9698.70.camel@twins>
Subject: Re: perf, x86: only do lbr init if bts is available
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Date: Thu, 24 May 2012 19:21:09 +0200
In-Reply-To: <1337879916.9698.69.camel@twins>
References: <4FBE5FA6.5050802@gmail.com> <1337879916.9698.69.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 19:18 +0200, Peter Zijlstra wrote:

> Right, as Stephane already noted, LBR is not an CPUID enumerated
> feature, hence the only thing you can do is go by model. So if you set
> qemu -cpu host but fail to implement all the architectural MSRs that go
> with that model you get to keep the pieces.

s/architectural//

They're called Model-Specific-Registers for a reason ;-)
