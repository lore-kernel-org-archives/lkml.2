Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab0HIRZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 13:25:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46003 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0HIRZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 13:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xkcD18Jb7lLSUwvkPfyC0R1Egc/eAaRYonnYt1xyfhxei/tv2rocYxcXkxY8EqaV6z
         CKIv76Ot2fQspg3by/GgJHm/AfwmMR4lXyg1Ae8ioESgSJSGMuU6/9jY5Y2Yc3Isal4o
         +jeMd/k38aWfC5DZbjjGIcrwIV6KBjYhJEP6c=
Date: Mon, 9 Aug 2010 21:25:42 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Andres Salomon <dilinger@collabora.co.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 4 (olpc_battery)
Message-ID: <20100809172542.GA6388@oksana.dev.rtsoft.ru>
References: <20100804151035.14678528.sfr@canb.auug.org.au>
 <20100804094755.e0377eb0.randy.dunlap@oracle.com>
 <20100809093925.1ff3dc11.randy.dunlap@oracle.com>
 <1281374272.7143.23.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1281374272.7143.23.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 06:17:52PM +0100, David Woodhouse wrote:
[...]
> > > drivers/power/olpc_battery.c:387: error: unknown field 'owner' specified in initializer
> > > drivers/power/olpc_battery.c:387: warning: excess elements in struct initializer
> > > drivers/power/olpc_battery.c:387: warning: (near initialization for 'olpc_bat_eeprom.attr')
> > > 
> > > 
> > > The .owner field has been dropped from the attr struct.
> > 
> > 
> > Build still fails in linux-next 20100809.
> 
> Anton, please pull from git://git.infradead.org/~dwmw2/battery-2.6.git
> (or I can just push it, but I figured I'd ask first).

Pulled and pushed back out, thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
