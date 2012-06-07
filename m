Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab2FGMyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 08:54:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7574 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab2FGMyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 08:54:23 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=8ShOI8NZQckA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=NwTCwuRChIJF6dPZksgA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339073661.7559.1.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] Use test_and_clear_bit() instead atomic_dec_and_test()
 for stop_machine
From: Steven Rostedt <rostedt@goodmis.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 07 Jun 2012 08:54:21 -0400
In-Reply-To: <87mx4zr0l9.fsf@devron.myhome.or.jp>
References: <87likkt7u6.fsf@devron.myhome.or.jp>
	 <87ehqct7a3.fsf@devron.myhome.or.jp>
	 <20120522214633.GB30024@home.goodmis.org>
	 <87aa0zty4r.fsf@devron.myhome.or.jp> <87mx4zr0l9.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 13:19 +0900, OGAWA Hirofumi wrote:
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
> 
> >> The down side to this is that it adds 4 more bytes on a 64bit
> >> machine. (sizeof(unsigned log) == 8 and sizeof(atomic_t) == 4)
> 
> Another patch without additional 4bytes. This simply change
> atomic_dec_and_test() to atomic_xchg().
> 

If nobody picked this up, you might want to resend it with my acked-by.
(The second patch, not the first). As patches added to replies are
usually ignored.

-- Steve


