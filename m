Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab1AGNgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 08:36:37 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45429 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab1AGNgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 08:36:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rA0sfclgto9NagA9FQWMQgr7StjbxBmfv12pOCgq5sbI5FTQKM+LdvaMU7kibqU8y/
         +COwPqUoxME+eaK9Yhm9+RgK+HKzK5mzOncPRl/KdIslBooGtWapNkhewZ5KMQIW2NYq
         jAcXUm6cw4ZtD3eiKPUo4GunJ2NsGyo+/+6yA=
MIME-Version: 1.0
In-Reply-To: <4D270F85.9070705@gmail.com>
References: <20110106002302.141581701@clark.site>
	<4D2691D4.3060304@gmail.com>
	<1294389025.2704.95.camel@edumazet-laptop>
	<4D270F85.9070705@gmail.com>
Date: Fri, 7 Jan 2011 15:36:35 +0200
X-Google-Sender-Auth: kjFVQcxeyjJ8VN9NulGwn71MaJQ
Message-ID: <AANLkTinkmnVLi7NrKsK50MBsycyYhyvEdtm01NA9ubOX@mail.gmail.com>
Subject: Re: [058/152] tcp: protect sysctl_tcp_cookie_size reads
From: Pekka Enberg <penberg@kernel.org>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi William,

On Fri, Jan 7, 2011 at 3:05 PM, William Allen Simpson
<william.allen.simpson@gmail.com> wrote:
> My instructors would have flunked me for not including braces around
> multi-line sequences; it was one of the great no-no's of the '70s.  Perhaps
> that's not the case anymore with modern colorful visual syntax checkers?

That's because your instructors hadn't read Documentation/CodingStyle
which didn't appear until the '90s.

                        Pekka
