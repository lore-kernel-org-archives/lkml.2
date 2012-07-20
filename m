Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab2GTNV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 09:21:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab2GTNV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 09:21:58 -0400
Date: Fri, 20 Jul 2012 09:21:53 -0400
From: Dave Jones <davej@redhat.com>
To: nicolas prochazka <prochazka.nicolas@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: oops in kernel ( 3.4.x -> 3.5rc )
Message-ID: <20120720132153.GA26110@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	nicolas prochazka <prochazka.nicolas@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <CADdae-i2FWspdm_BPQAeO3HUUyOWj8rDui0cTGR6fkRv7yr2zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADdae-i2FWspdm_BPQAeO3HUUyOWj8rDui0cTGR6fkRv7yr2zw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 11:56:06AM +0200, nicolas prochazka wrote:
 
 > [ 2384.900061] BUG: unable to handle kernel paging request at 000000010000002f

That '1' looks like a random bit flip. Try running memtest86.

 > [ 2384.910010] Pid: 23838, comm: queue.sh Tainted: G      D W

This wasn't the first problem either.

 > [ 2397.885344] BUG: unable to handle kernel paging request at 000000010000003b

Looks like the same flipped bit.

	Dave

