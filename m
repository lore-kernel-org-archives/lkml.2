Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab0FJGKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 02:10:45 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39912 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab0FJGKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 02:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=H4kE4pW5Ze/BpjxVgvZovltiv7EpsngteGnpMIMjuhoxkn6JAo0qY6zMUdqWJhw1m1
         qfHNpB64T6K3NRVM5bQU5X5WuaRswKrJtEXHWi8k20p4qGkYTyjzUG3ZucAaFrh1sDFq
         2DJ8aJNGCXteQ6qUCzrQ8Wdhv3SKeJCku8gbs=
MIME-Version: 1.0
In-Reply-To: <AANLkTim49akRJK0BN_Qk1wL6e5mrdjZioDjGNWlrjUVQ@mail.gmail.com>
References: <20100519154618.GA26381@atrey.karlin.mff.cuni.cz> 
	<AANLkTim49akRJK0BN_Qk1wL6e5mrdjZioDjGNWlrjUVQ@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 10 Jun 2010 14:10:22 +0800
Message-ID: <AANLkTilCvgvf9Ch55f878nTNTue8tHYmcrLEywsjnylY@mail.gmail.com>
Subject: Re: usb gadget on zaurus and kexec
To: Cyril Hrubis <metan@ucw.cz>
Cc: pave@ucw.cz, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       zaurus-devel@www.linuxtogo.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 1:05 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Wed, May 19, 2010 at 11:46 PM, Cyril Hrubis <metan@ucw.cz> wrote:
>> Hi!
>> After some testing I found out that no usb gadget (g_ether, g_mass_storage, ...)
>> is working after zaurus boots with kexec. So it seems like some missing
>> initalization (it's working after doing reboot again) anybody has any clue,
>> patch or ideas how to debug this?
>>
>
> Dumping out the registers of the two situations and doing a comparison then
> might be a quick way.
>

Any debugging update on this?
