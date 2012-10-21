Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab2JUNbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 09:31:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55544 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab2JUNbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 09:31:18 -0400
Date: Sun, 21 Oct 2012 15:31:01 +0200
From: Heinz Diehl <htd@fritha.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Martin Peres <martin.peres@labri.fr>,
        Heinz Diehl <htd@fancy-poultry.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
Message-ID: <20121021133101.GA23022@fritha.org>
References: <1724445.dN2yMEzN6d@localhost>
 <20121020212036.GA1698@fritha.org>
 <20121020221948.GE5826@joi.lan>
 <2155889.FOmdXlva7q@localhost>
 <20121021120901.GA22587@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121021120901.GA22587@joi.lan>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+66 (70810a88ce9f) (2011-07-01)
X-Provags-ID: V02:K0:oyG+K2llj88h6coLeo7H4dVo4owaKCWMux2bjl1jsNM
 X91isK05ya1mIxSCSCq049g5JuVPlohFLiPPpvjexKxVPqWCUf
 H+q2vV9lViunO0oGy4ixApMiCip8a5z0wL3LegOjLvZfzZv9Et
 YqZYfTpePZMgk8zNOx9ngKSTGDZjwWDHYuadT3ivbkIc5LVq+A
 rPOFUK/zB2A4id5A4dJm6slgJUB71oau0bpKFv/OvwVVbzugcy
 Khk0aDzCjNObpH78ZGhb6rxNAH9Vyg69jcfAz5rZrhImYlKw7x
 Leks+64Yn6WnT1gycpR9Aw+HfA6DjdpWbfcvc0nhjIMhjDnbSQ
 t6K+EfBu3+xHn+T3bQOE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.10.2012, Marcin Slusarz wrote: 

> > > Please attach acpidump output.
> > 
> > http://pluto.agmk.net/nv/acpidump.txt
> > 
> 
> This looks like ACPI bug...

I guess my acpidump didn't make it to the list. Anyway, here it is:

http://www.fritha.org/acpidump.gz

