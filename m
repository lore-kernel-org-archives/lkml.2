Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab0KIEVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 23:21:01 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33775 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab0KIEUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 23:20:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Te0Pc6Zdf8TcyEq+CEvuBIa2MGQryMQw6uHfQO79IUkjYsxlGePEIadZPlCxKHLdAn
         c6/hfrPH6VGlADhqp56+zvcUGBW0HGDd6nIq9gjg8QcqIPEBJikAhL/NavqCZcxLBgy7
         jkpjnNNw3hQYrpSYfn9FpxzvpkbF9JH3nIuYg=
Date: Tue, 9 Nov 2010 12:25:35 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mike Waychison <mikew@google.com>, simon.kagstrom@netinsight.net,
        davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>, adurbin@google.com,
        linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>,
        =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v2 00/23] netoops support
Message-ID: <20101109042535.GB5220@cr0.nay.redhat.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <87k4knqo91.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k4knqo91.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 02:28:26AM +0100, Andi Kleen wrote:
>Mike Waychison <mikew@google.com> writes:
>
>I'm still not fully convinced this needs to be a fully separate
>mechanism from netconsole.  It seems a lot of work to implement
>basically log level.
>
>Maybe netconsole could be patched to support only dumping KERN_EMERG?
>

I tend to agree, IMHO, we can introduce another parameter like "oops_only"
to netconsole.


>But I guess the structured logging has some advantages, although
>there have been certainly oops parsers (e.g. kerneloops.org) without it.
>

+1
