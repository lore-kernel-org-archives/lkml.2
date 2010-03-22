Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab0CVSy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:54:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab0CVSyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:54:25 -0400
Date: Mon, 22 Mar 2010 18:54:09 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dave Wysochanski <dwysocha@redhat.com>,
       Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [patch 114/123] dm ioctl: only issue uevent on resume if state
	changed
Message-ID: <20100322185409.GL919@agk-dp.fab.redhat.com>
Mail-Followup-To: Greg KH <gregkh@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
	stable@kernel.org, stable-review@kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Dave Wysochanski <dwysocha@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
References: <20100313001618.GA9811@kroah.com> <20100313001515.103664129@kvm.kroah.org> <20100322184314.GA7534@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322184314.GA7534@redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 02:43:17PM -0400, Mike Snitzer wrote:
> The following upstream dm-ioctl patch also needs to go to stable now
 
Ack.

This is for the benefit of systems that have switched over to using udev
rules to manage dm devices (instead of dm/lvm2 code).  The userspace
code that issued the ioctl needs to be told whether or not a uevent was
issued so that it knows whether or not there is udev processing to wait
for.

Alasdair

