Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab2ECV1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:27:09 -0400
Received: from corega.com.ru ([195.178.208.66]:41927 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755522Ab2ECV1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:27:08 -0400
Date: Fri, 4 May 2012 01:27:06 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] w1: Introduce a slave mutex for serializing IO.
Message-ID: <20120503212706.GA26612@ioremap.net>
References: <20120425124914.3187a794@notabene.brown>
 <20120501213958.GA15560@ioremap.net>
 <20120502162627.50544c8b@notabene.brown>
 <20120503175857.GA13988@ioremap.net>
 <20120504070838.5bd23110@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120504070838.5bd23110@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 07:08:38AM +1000, NeilBrown (neilb@suse.de) wrote:
> You can only check the owner on SMP builds, or when debugging is enabled.
> So I don't think that approach can work.

You can store owner in master device and protect with mutex itself.
On non-smp systems it can not be preempted, so can be checked without
mutex.

-- 
	Evgeniy Polyakov
