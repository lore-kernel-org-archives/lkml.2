Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2BVPOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 10:14:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50703 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab2BVPOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:14:22 -0500
Message-ID: <4F45062C.8000104@zytor.com>
Date: Wed, 22 Feb 2012 07:13:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        autofs@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: compat: autofs v5 packet size ambiguity - update
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>  <20120221.221609.218135609185671883.davem@davemloft.net>  <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>  <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>  <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com>  <1329889428.2193.45.camel@perseus.themaw.net>  <1329890027.2193.48.camel@perseus.themaw.net>  <1329890251.2193.50.camel@perseus.themaw.net> <1329903139.2193.66.camel@perseus.themaw.net>
In-Reply-To: <1329903139.2193.66.camel@perseus.themaw.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 01:32 AM, Ian Kent wrote:
> 
> Oh, DOH ... 
> 
> The process mounting the autofs mount is passing the pipe it will use
> for communication via a mount option so we can do this right in
> fill_super.
> 

Does that mean that the autofs v5 daemon calls mount() by itself, unlike
the older autofs daemon?  Otherwise you're reading the compatness of
/bin/mount...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

