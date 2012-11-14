Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423171Ab2KNRxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:53:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50170 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423120Ab2KNRw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:52:59 -0500
Message-ID: <50A3DA75.60208@zytor.com>
Date: Wed, 14 Nov 2012 09:52:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephan Mueller <stephan.mueller@atsec.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: drivers/char/random.c: variable type mismatch
References: <509AFDA6.7070005@atsec.com> <20121108114708.GB5859@thunk.org> <50A3C3A8.4060509@atsec.com>
In-Reply-To: <50A3C3A8.4060509@atsec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 08:15 AM, Stephan Mueller wrote:
>
> I agree with the argument of correlation.
>
> So, if the reduction of values with a known lack of entropy is of
> interest, why not change the jiffies variable type too? There we know
> that only the lower 32 bits are really relevant. Therefore, wouldn't be
> a structure of
>
>          struct {
>                  unsigned jiffies;
>                  unsigned cycles;
>                  unsigned num;
>          } sample;
>
> be more appropriate?
>

Probably.  It doesn't make much difference, however.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

