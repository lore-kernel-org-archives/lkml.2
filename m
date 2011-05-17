Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab1EQQ3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 12:29:34 -0400
Received: from sycorax.lbl.gov ([128.3.11.121]:59532 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab1EQQ3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 12:29:33 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: system hangs 2.6.39-rc7 xfs related
References: <87ei3y7aei.fsf@sycorax.lbl.gov>
	<20110517155018.GB17735@infradead.org>
Date: Tue, 17 May 2011 09:29:22 -0700
In-Reply-To: <20110517155018.GB17735@infradead.org> (message from Christoph
	Hellwig on Tue, 17 May 2011 11:50:19 -0400)
Message-ID: <87r57xl28t.fsf@sycorax.lbl.gov>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Mon, May 16, 2011 at 11:44:37AM -0700, Alex Romosan wrote:
>> my system just sort of locked up and everything that's trying to write
>> to disk is stuck. dmesg gives me this:
>
> This looks quite similar to a few other XFS issues in the .39 cycle.
> Can you upgrade to latest Linus HEAD which has fixes for these similar
> issues and see if that fixes your issues?

i'll give it a try, but it might take some time before i can figure out
if the fixes work as i still haven't figured out a way to reproduce
this consistently (having a lot of processes write to disk at the same
time increases the likelihood of it happening but doesn't guarantee it).

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
