Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654Ab1COMlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 08:41:03 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:52836 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757590Ab1COMlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 08:41:01 -0400
Message-ID: <4D7F5E2B.6090805@secunet.com>
Date: Tue, 15 Mar 2011 13:40:11 +0100
From: Torsten Hilbrich <torsten.hilbrich@secunet.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Anton Altaparmakov <aia21@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Andreas_Bie=DFm?= =?ISO-8859-1?Q?ann?= 
	<biessmann@corscience.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] fs-writeback: fix NULL pointer dereference in, __mark_inode_dirty
References: <fa.8ND6HoGS9dKYUuniFCAoNq+1TFY@ifi.uio.no> <4D78AA72.3060202@secunet.com> <4D7F3CD5.9030105@secunet.com> <99773600-FC41-41A9-8544-BF7E09065546@cam.ac.uk>
In-Reply-To: <99773600-FC41-41A9-8544-BF7E09065546@cam.ac.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Mar 2011 12:40:59.0354 (UTC) FILETIME=[3C7503A0:01CBE30E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.03.2011 13:11, Anton Altaparmakov wrote:

> This is already being handled.  It is the same as other bug reports, i.e. the fact that sb->s_bdi is made NULL on device removal and if it happens at the wrong time you then get a NULL pointer dereference.
> 
> Jens Axboe just only yesterday posted an initial patch for this.  Can you please test it and report back if it does indeed cure the problem?
> 
> The patch can be found here for example:
> 
> 	https://lkml.org/lkml/2011/3/14/25
> 

This patch fixes the problem for my test szenario.

	Torsten

