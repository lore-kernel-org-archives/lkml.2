Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab1LNOG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:06:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab1LNOG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:06:57 -0500
Date: Wed, 14 Dec 2011 12:06:12 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Nate Custer <nate@cpanel.net>, kvm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: kvm deadlock
Message-ID: <20111214140612.GG18317@amt.cnet>
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net>
 <20111214122511.GD18317@amt.cnet>
 <4EE8A7ED.7060703@redhat.com>
 <20111214140027.GF18317@amt.cnet>
 <4EE8AC88.1040205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE8AC88.1040205@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 04:02:48PM +0200, Avi Kivity wrote:
> On 12/14/2011 04:00 PM, Marcelo Tosatti wrote:
> > The other traces have apparently bogus NMI interrupts, but it might be a
> > software bug, OK.
> 
> These are from sysrq-blah, no?  I'm looking at them now.

I don't know. Its a hang ? It could be memory corruption (of the timer
olist) instead of a bogus NMI actually, the second.

Nate?


