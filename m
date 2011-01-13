Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab1AMTWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 14:22:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab1AMTV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 14:21:59 -0500
Date: Thu, 13 Jan 2011 19:21:52 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] core block bits for 2.6.38
Message-ID: <20110113192152.GA18217@agk-dp.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Jens Axboe <jaxboe@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4D2F03A7.2030809@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2F03A7.2030809@fusionio.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 02:52:39PM +0100, Jens Axboe wrote:
> Below are the core block bits for 2.6.38.
 
> Tejun Heo (17):
>       block: simplify holder symlink handling

This one was found to be causing problems in linux-next yesterday: 
  http://permalink.gmane.org/gmane.linux.file-systems/50132

Perhaps you could drop it for now until a solution's found?

Thanks,
Alasdair

