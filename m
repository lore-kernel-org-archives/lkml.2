Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1CWHcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 03:32:31 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48658 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab1CWHc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 03:32:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Avgs2rJ6OSUWzRWC9VH6BZ364fqWwUGBIWrTgdVhCoXR8ote0SS0/UIMi4Xo7l6Lb5
         gFsJulWKcqU+vioCtKCVQqeSDXoAxe3LXi9ETed22H/NMoBYRZm+R+OUWhkkxxrsbgoF
         O2s+oFGnW7s/QAOTse0bmdfKGFgtTcbvgs3Uo=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110209183816.GD9533@thunk.org>
References: <AANLkTinXsDN4Bhp9_kcbeu6BNMADTSBVN_6+nn63w+kW@mail.gmail.com>
	<20110209183816.GD9533@thunk.org>
Date: Wed, 23 Mar 2011 08:32:28 +0100
Message-ID: <AANLkTi=4k7QrtPg1B7bbzNzVMjj_aKwq99+DByQo2BP6@mail.gmail.com>
Subject: Re: [ext4] Multiple page-io submission (Option "mblk_io_submit")
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "Ted Ts'o" <tytso@mit.edu>, sedat.dilek@gmail.com,
        Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: "s.dilek" <s.dilek@jpberlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 7:38 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Feb 08, 2011 at 06:30:29PM +0100, Sedat Dilek wrote:
>> Hi,
>>
>> while looking at pending patches in ext4.git#{master, for_linus}, I
>> saw "ext4: Fix data corruption with multi-block writepages support"
>> which should fix [2] according to text in the commit-body.
>>
>> Are you planning to turn on "multiple page-io submission" again by
>> default (as is was disabled in "ext4: Turn off multiple page-io
>> submission by default" [3])?
>
> I'm planning on turning it on by default post 2.6.38, during the
> 2.6.39-rc1 merge window.  That's me being paranoid, since this is so
> late in the -rc cycle for 2.6.38.
>
>                                                - Ted
>

Ping!
(As the merge-window is still open.)

- Sedat -
