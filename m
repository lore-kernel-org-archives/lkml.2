Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460Ab2JaSDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:03:05 -0400
Received: from mail.agmk.net ([91.192.224.71]:49090 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757790Ab2JaSDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:03:03 -0400
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: skinsbursky@parallels.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, baggins@pld-linux.org,
        arekm@pld-linux.org
Subject: Re: [PATCH] lockd: fix races in per-net NSM client handling
Date: Wed, 31 Oct 2012 19:02:57 +0100
Message-ID: <4005626.trvd4a4buj@localhost>
User-Agent: KMail/4.9.1 (Linux/3.6.4; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121031174946.GA13591@kroah.com>
References: <1689813.hptKgzjpAu@localhost> <20121031174946.GA13591@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 of October 2012 10:49:46 Greg KH wrote:
> On Wed, Oct 31, 2012 at 06:27:36PM +0100, Paweł Sikora wrote:
> > Hi,
> > 
> > the patch metioned in https://lkml.org/lkml/2012/10/24/175 seems to fix
> > the 3.6.3 oops (while 3.6.2 works fine) at 16-cores opteron server.
> > please queue this path for 3.6.$next.
> 
> Is it in Linus's tree already?  If so, what is the git commit id?

the mainstream contains some lock deamon fixes already:

* e498daa LOCKD: Clear ln->nsm_clnt only when ln->nsm_users is zero
* a4ee8d9 LOCKD: fix races in nsm_client_get

but i don't know where is the right fix. Stanislav, could you put some light on this?

BR,
Paweł.

