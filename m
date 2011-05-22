Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205Ab1EVAPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 20:15:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41447 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab1EVAPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 20:15:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tiCdLblqUXqlL5SP6JwsiBYwKot1OwjiogCd9L9G6QKtkT4EBug2PIM+usAYd7JNA6
         mTLoCcyQqtDz02z8EEuQ==
MIME-Version: 1.0
In-Reply-To: <20110521214910.GB5912@suse.de>
References: <20110519183127.122729561@clark.kroah.org>
	<alpine.LSU.2.00.1105201026430.9887@sister.anvils>
	<20110521214910.GB5912@suse.de>
Date: Sat, 21 May 2011 17:15:16 -0700
Message-ID: <BANLkTinwotVyU-DfvpVVpY3jWg0s+NGE8w@mail.gmail.com>
Subject: Re: [15/24] tmpfs: fix spurious ENOSPC when racing with unswap
From: Hugh Dickins <hughd@google.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
        stable-review@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 2:49 PM, Greg KH <gregkh@suse.de> wrote:
> On Fri, May 20, 2011 at 10:49:59AM -0700, Hugh Dickins wrote:
>> On Thu, 19 May 2011, Greg KH wrote:
>> > 2.6.33-longterm review patch.  If anyone has any objections, please let us know.
>>
>> We've got in a muddle on this one: too many tmpfs races and too many trees!
>
> Yeah, it's messy :(

>>
>> For differing reasons, none of these races is as likely in 2.6.33
>> as in 2.6.38, but good to include the fixes anyway; whereas 2.6.32
>> gets more complicated for some of them, so I haven't bothered there.
>>

> Ok, as this really isn't a big deal for .33, how about I just drop all
> of the tmpfs patches for .33-longterm and we call it a day :)
>
> It's easier that way for me by far.

Fair enough, I've given you enough headaches, and none of these were
noticed back then: drop 'em all!

Thanks,
Hugh
