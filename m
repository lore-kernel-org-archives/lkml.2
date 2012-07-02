Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab2GBQtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:49:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab2GBQtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:49:35 -0400
Date: Mon, 2 Jul 2012 18:46:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [ 11/48] mm: correctly synchronize rss-counters at exit/exec
Message-ID: <20120702164655.GA15285@redhat.com>
References: <20120701172008.252571630@decadent.org.uk> <alpine.LSU.2.00.1207011150480.1905@eggly.anvils> <1341194519.4852.128.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341194519.4852.128.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02, Ben Hutchings wrote:
>
> Then I'll assume this should be dropped unless Konstantin or Oleg speaks
> up for it.

Just in case, I agree with Hugh.

The patch should shut up check_mm() which doesn't exist in 3.2

Oleg.

