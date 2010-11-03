Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0KCIDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 04:03:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54338 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab0KCIDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 04:03:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gHI2Olds9i8DwqoYqe3oOFRNu3O6S6FA9nEq5mA8Cij8bA0xTIfXAg28ReFhumsgaE
         629p9dFH8kwBovcHdJ5qDfLXemKU8qrlim4UP/UlOpX7EIIEiMNbHK7yEdcsnKrZTvMy
         rKqoV5lGOlwgs1FmZ9zIXs2X0Na/eM8HXkD8k=
Date: Wed, 3 Nov 2010 08:02:58 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.35->2.6.36 regression, vanilla kernel panic, ppp or
	hrtimers crashing
Message-ID: <20101103080258.GB7279@ff.dom.local>
References: <20101028070550.GA7647@ff.dom.local> <201011021549.47466.nuclearcat@nuclearcat.com> <20101103073854.GA7279@ff.dom.local> <201011030947.54464.nuclearcat@nuclearcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011030947.54464.nuclearcat@nuclearcat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 09:47:53AM +0200, Denys Fedoryshchenko wrote:
> I try to reverse and got very weird lockups (no netconsole logs and no 
> watchdog triggered reboot on that remote machine).
> I will try to cook something to reboot it, because it is very remote machine

OK, I only wanted to know if reverting could be a fast fix. Since it
isn't, please stay with 2.6.35 until there is some new idea (patch).

Jarek P.
