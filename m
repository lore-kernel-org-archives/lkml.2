Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab2LQT2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:28:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46180 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab2LQT2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:28:15 -0500
Message-ID: <50CF7249.3030504@kernel.dk>
Date: Mon, 17 Dec 2012 20:28:09 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] core block IO bits for 3.8
References: <50CF3B82.9000904@kernel.dk> <x49licwwtm8.fsf@segfault.boston.devel.redhat.com> <20121217170016.GA2592@htj.dyndns.org> <50CF50AA.7080600@kernel.dk> <x49ehiowqga.fsf@segfault.boston.devel.redhat.com> <50CF6D35.5040300@kernel.dk> <CA+55aFxoN+4Nu1YB=b+3eTWKq=_h_cN5i2DVzeYCEqNyN_PwZA@mail.gmail.com>
In-Reply-To: <CA+55aFxoN+4Nu1YB=b+3eTWKq=_h_cN5i2DVzeYCEqNyN_PwZA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-17 20:27, Linus Torvalds wrote:
> On Mon, Dec 17, 2012 at 11:06 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Sigh, in that case, yes lets just revert it.
> 
> So just to check - we're talking about commit 8fa72d234da9 ("bdi: add
> a user-tunable cpu_list for the bdi flusher threads"). It reverts
> cleanly, but I wanted to make sure we're all on the same page..

That is the one, revert at will :-)

-- 
Jens Axboe

