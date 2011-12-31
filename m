Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab1LaLsF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 06:48:05 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53317 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab1LaLsB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 06:48:01 -0500
MIME-Version: 1.0
In-Reply-To: <20111227184734.GA5802@redhat.com>
References: <CA+55aFxw1abaxwQbX=sQVF-J6drk8m5cKCd+rMqrpoS5vohmnA@mail.gmail.com>
	<20111227184734.GA5802@redhat.com>
Date: Sat, 31 Dec 2011 12:47:59 +0100
Message-ID: <CAFQmdRYn6VVGVoDN+-_5jfme2a_W2Z-H8J8TsdtdXJmC=LY7cA@mail.gmail.com>
Subject: Re: Linux 3.2-rc7
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 7:47 PM, Dave Jones <davej@redhat.com> wrote:
> On Fri, Dec 23, 2011 at 10:16:06PM -0800, Linus Torvalds wrote:
>  > There it is, likely the last -rc in before final 3.2, so please do
>  > check it out in between your holiday festivities.
>  >
>  > Most of the changes are faily simple one-liners, but some qla4xxx
>  > driver updates stand out and in fact account for about 40% of the diff
>  > ("qla4xxx: fix flash/ddb support"). That, together with a VMWare DRI
>  > driver update and some dvb updates and the regular random driver fixes
>  > means that 80+% of the changes are in drivers.
>  >
>  > Some net updates, some SH updates, and then a (tiny) smattering of
>  > other stuff. The appended shortlog gives the (fairly boring) details,
>
> https://lkml.org/lkml/2011/11/22/753 has been around since rc2, and is
> still appearing every boot for me.  I'm not sure if Havard had patches
> fixing this or not, I lost track.

Yes, I did, and Greg picked them up. Not sure what happened after that.

(sorry about the delay; I'm on vacation and have been offline for a few days)

Havard
