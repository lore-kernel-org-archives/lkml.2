Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1CKAez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:34:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044Ab1CKAex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:34:53 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTik3AyFTNoytebmOOZ=JSFMkt0bw7au-CSncUHJu@mail.gmail.com>
References: <20110310.153444.115930379.davem@davemloft.net>
 <AANLkTimnHtVS=SFopgyjAAQDW8bXDKDXf+YvEtPdpPsA@mail.gmail.com>
 <20110310.155556.48513201.davem@davemloft.net> <AANLkTik3AyFTNoytebmOOZ=JSFMkt0bw7au-CSncUHJu@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 Mar 2011 16:34:32 -0800
Message-ID: <AANLkTiktUsR1vXo84H2m_tLZRgDGee+JdvxGZjX7hYMq@mail.gmail.com>
Subject: Re: [GIT] Networking
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 4:29 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Oh well. Water under the bridge. I think I'll try --no-ff this once,
> despite my misgivings about the concept.

Oh wow. That really does end up looking odd. I know some other git
projects use --no-ff, but I don't think we've ever had them in the
kernel, and I've never see the graph look like that before.

But it did allow me to add an explanation for what happened, so maybe
it's worth it.

                     Linus
