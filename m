Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760792Ab0HLTFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:05:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52130 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886Ab0HLTFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:05:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=xTvB2wSGE4yIpeBMTeAjzhQXAKFbDAlMWW3ZlStlLuHD5ZFFKZQFmnTTzL49rzl3KM
         heTl88F/zNXCgQrQqZ2o8jioi9QmpzZ6mtBCJEl5zHWA7hRXGnan8GhaEnp+nly3LqWo
         Zqo3AQaAGB8EZnYmcrtmkSihPCNSQjLc27qTU=
MIME-Version: 1.0
In-Reply-To: <20100812182128.GC2763@thunk.org>
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<Pine.LNX.4.44L0.1008120733130.21006-100000@netrider.rowland.org>
	<AANLkTinMwt27wuDUh32F36wpoC54Syzp1_nK9UCxYmEK@mail.gmail.com>
	<20100812125248.GA2763@thunk.org>
	<AANLkTin4=qpDWEKLwes_af6mSCW+ED7v-fWzD34JywU1@mail.gmail.com>
	<20100812182128.GC2763@thunk.org>
Date: Thu, 12 Aug 2010 22:05:30 +0300
Message-ID: <AANLkTinZ_gViUjVmEbkmour3BC=PcchJDARs4GaCuQwO@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, Felipe Contreras <felipe.contreras@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, paulmck@linux.vnet.ibm.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, peterz@infradead.org,
        tglx@linutronix.de, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, arjan@infradead.org, swmike@swm.pp.se,
        galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 9:21 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Aug 12, 2010 at 07:46:03PM +0300, Felipe Contreras wrote:
>
>> All the Android community had to do is push the drivers *without*
>> suspend blockers, then the Android kernel wouldn't be so different and
>> thus wouldn't be considered a fork. AFAIU the kernel side wakelocks
>> are already in the kernel, so there's no excuse not to merge the
>> drivers.
>
> What's there is not good enough, because it's missing the statistics
> and reporting so that badly behaved kernel and userspace drivers that
> take wakelocks can be found.

You don't need to have all the code merged in, hell, you only needed
wakelock stubs.

You should take the point of view of the community as a whole, and
forget about Android for a second; the important thing is to bring the
code-bases closer, and that means merging the drivers. For that, you
don't need anything extra.

-- 
Felipe Contreras
