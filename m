Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab0G1Gwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 02:52:33 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59885 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab0G1Gwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 02:52:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J1psAZK0cSab+JAmq05MAvlcA9UcSazpo6FEyvgiH8dY9eo1MaW8lTBFmiZiEHoGpn
         xQUP3rzvczHzLHpEFWLb28+e9YUILFPzj0Ug2UDfMg5sX58p7J/7E7tH0sB9gf5k+/yW
         BS/4PG9s+z8lq8IiPdF9W1AXWg6rCcKEyd/qQ=
Date: Wed, 28 Jul 2010 14:56:40 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Davidlohr Bueso <dave.bueso@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alexey Dobriyan <adobriyan@gmail.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] [PATCH procfs] Add process age
Message-ID: <20100728065640.GD5161@cr0.nay.redhat.com>
References: <1279907271.4335.3.camel@cowboy>
 <20100723183549.GA10518@x200>
 <1279910830.1851.5.camel@cowboy>
 <87fwz6it0e.fsf@basil.nowhere.org>
 <1280152668.2212.1.camel@cowboy>
 <20100726144848.GC17756@basil.fritz.box>
 <1280157029.2212.17.camel@cowboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280157029.2212.17.camel@cowboy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 11:10:29AM -0400, Davidlohr Bueso wrote:
>On Mon, 2010-07-26 at 16:48 +0200, Andi Kleen wrote:
>> > True, but there are also many other no-so-useful files under /proc that
>> > can also be replaced by userspace apps.
>> 
>> Example? 
>
>Off the top of my head:
>
>/proc/cmdline

Are you kidding?

/proc/cmdlines contains lots of info, it is not only used by the kernel,
but also used by initramfs (this depends on your distribution).

