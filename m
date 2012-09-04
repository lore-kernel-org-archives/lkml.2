Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab2IDUhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:37:54 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48975 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab2IDUhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:37:45 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: a3at.mail@gmail.com
In-Reply-To: <20120904031544.GI5066@thunk.org>
References: <CAAW1UO-q5uUe4zG5BnB0z9dyKCqRRWH4sriyu7Fj6XinE7GKzA@mail.gmail.com>
	<20120904031544.GI5066@thunk.org>
Date: Wed, 5 Sep 2012 00:37:43 +0400
X-Google-Sender-Auth: U0sJnl1YaRR4uPiMGT1k6SbAPL4
Message-ID: <CAAW1UO_SL1N0yyVUrOyhrj=ZSpQu3odMN634mHZf4Nyr0n7hEQ@mail.gmail.com>
Subject: Re: western digital caviar black. EXT4-fs error
From: Azat Khuzhin <dohardgopro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted, many thanks!
I'll try to compile new kernel (maybe 3.4.x)

On Tue, Sep 4, 2012 at 7:15 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sat, Sep 01, 2012 at 11:48:17PM +0400, Azat Khuzhin wrote:
>> Recently I update my HDD on desktop machine, and bought WD Caviar Black.
>> But after I format & copy information to it (using dd), and fix
>> partitions size: I have next errors in kern.log:
>>
>> Aug 28 01:49:03 home-spb kernel: [183245.030897] EXT4-fs error (device
>> sdc2): ext4_mb_generate_buddy:739: group 3675, 32254 clusters in
>> bitmap, 32258 in gd
>
> Sorry for the delay; you sent this to linux-kernel (and not the
> linux-ext4 list).  It also took me a while to dig up the relevant fix
> from my archives; normally, once a bug has been fixed (as this one
> was, on June 7, 2012) I don't worry about it any more.
>
> The upstream fix is commit b0dd6b70f0fda17ae9762fbb72d98e40a4f66556.
>
> Note that you are using the 3.3.0 kernel.  This is a not long-term
> supported kernel, so fixes from upstream are no longer being
> backported to it.  The official Debian kernel (which tracks the 3.2.x
> stable kernel series) has the backported bug fix.  So does the 3.4
> long-term stable kernel series, as does the 3.5 kernel or any later
> kernel.
>
> If you don't know how to backport a kernel patch, or even if you do, I
> would strongly suggest that you either go back to the Debian standard
> kernel for Wheezy, or track the 3.2.x or 3.4.x long-term stable
> kernel.  (The fix is in v3.2.20 or later, and v3.4.3 or later ---
> where those trees are up to v3.2.28, and v3.4.10, respectively.)
> Otherwise, you may very well run into some other kernel bug which has
> already been fixed upstream, and you'll just waste your time as well
> as various other kernel developers.
>
> Regards,
>
>                                                 - Ted



-- 
Azat Khuzhin
