Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab0KOLSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 06:18:41 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35811 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab0KOLSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 06:18:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qnZZpACgcS+8wrxOHsup4H+RnPnZ+yKX+1wCDxw0D685FtXYotqqWMnTkyhLQrcYU0
         vIDu+4vvRhLNkCwwTqFx0v2yZp00ZiZb70Te7qpy/4eE8Mac9wY/UHJ/dcMvjL6n9RTC
         dhN3081nwUDY5w5/4GS9HXqaBR+9uJtMHWV8Q=
MIME-Version: 1.0
In-Reply-To: <AANLkTind92uwcigzmDn8yn9a22exDy7zcreGQ5-6NLV-@mail.gmail.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
	<1289489007.17691.1310.camel@edumazet-laptop>
	<AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
	<ZXmP8hjgLHA.4648@exchange1.tad.internal.tilera.com>
	<4CDF1945.8090101@tilera.com>
	<AANLkTind92uwcigzmDn8yn9a22exDy7zcreGQ5-6NLV-@mail.gmail.com>
Date: Mon, 15 Nov 2010 19:18:38 +0800
Message-ID: <AANLkTinzRm_5WW5HwxzXqZZD4255GDpR4yzELqz66Dfn@mail.gmail.com>
Subject: Re: Kernel rwlock design, Multicore and IGMP
From: Cypher Wu <cypher.w@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In that post I want to confirm another thing: if we join/leave on
different cores that every call will start the timer for IGMP message
using the same in_dev->mc_list, could that be optimized?

-- 
Cyberman Wu
http://www.meganovo.com
