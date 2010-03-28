Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab0C1Dl4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 23:41:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:37090 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab0C1Dlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 23:41:55 -0400
Date: Sat, 27 Mar 2010 20:42:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu, npiggin@suse.de,
       mingo@elte.hu, Ruald Andreae <ruald.a@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
Message-ID: <20100327204233.0d84542a@infradead.org>
In-Reply-To: <4baeaee5.c5c2f10a.7187.2688@mx.google.com>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
	<4baeaee5.c5c2f10a.7187.2688@mx.google.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Mar 2010 18:20:37 -0700 (PDT)
Ben Gamari <bgamari.foss@gmail.com> wrote:

> Hey all,
> 
> I have posted another profile[1] from an incident yesterday. As you
> can see, both swapper and init (strange?) show up prominently in the
> profile. Moreover, most processes seem to be in blk_peek_request a
> disturbingly large percentage of the time. Both of these profiles
> were taken with 2.6.34-rc kernels.
> 
> Anyone have any ideas on how to proceed? Is more profile data
> necessary? Are the existing profiles at all useful? Thanks,


profiles tend to be about cpu usage... and are rather poor to deal with
anything IO related.

latencytop might get closer in giving useful information....

(btw some general suggestion.. make sure you're using noatime or
relatime as mount option) 
-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
