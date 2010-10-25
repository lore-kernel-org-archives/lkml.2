Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab0JYEuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 00:50:20 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40587 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab0JYEuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 00:50:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EbTbFe0EvsUhDjEBDUXc+aPc60yk+/BcsK6u29lepEQQyNoo9BHYqHHZjdwvY5b9/a
         aQl7IgmDOPQ2Uj0/zuJ1Mcf8iUlmpTdj0/um5xO8UDCcaqTbJxuebe1i77S6Xso+3Qwy
         /blmvugu8DRYXt9ZI1qdSjCp5zOtsuyAIz/6I=
Date: Sun, 24 Oct 2010 21:50:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Samuel Thibault <sthibault@debian.org>, Tom Vier <tom@triadsys.com>,
        594089@bugs.debian.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Bug#594089: keyboard-configuration: caps lock keycode problem
Message-ID: <20101025045003.GA1438@core.coreip.homeip.net>
References: <20100823154353.2805.13525.reportbug@tom.tse>
 <20100903235540.GA9149@const>
 <4C866913.3030201@triadsys.com>
 <4C8E6861.1070502@triadsys.com>
 <20101024144150.GV24091@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101024144150.GV24091@const.famille.thibault.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 04:41:51PM +0200, Samuel Thibault wrote:
> The short story is: Tom's keyboard sends all that when he presses caps
> lock:
> 
> press: 0x3a 0xe0 0x66
> repeat: 0x3a
> release: 0xba 0xe0 0xe6
> 
> 0xe0 0x66 happens to be the "favorites" key on his keyboard with
> internet navigation keys.  I thus believe there's a bug in his keyboard
> that needs to be filtered at the kernel level.
> 
> The long story can be read on http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594089

Hmm, the question is whether the real "favorites" key send the same
usage and the fake one after caps lock. Any chance Tom could locate
evtest utility and see what MSC_SCAN events being emitted?

Thanks.

-- 
Dmitry
