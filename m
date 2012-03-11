Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2CKVcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 17:32:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59587 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2CKVcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 17:32:25 -0400
Date: Sun, 11 Mar 2012 14:32:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>
cc: Arnaud Lacombe <lacombar@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: randconfig chosing more than one slab allocator
In-Reply-To: <alpine.DEB.2.00.1203041404590.18555@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1203111432020.790@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1203041404590.18555@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Mar 2012, David Rientjes wrote:

> Hi folks,
> 
> make randconfig seems to allow chosing more than one slab allocator 
> although they are all part of a choice,endchoice block (and none are 
> tristate).  The following quickly finds both CONFIG_SLUB and CONFIG_SLOB 
> enabled:
> 
> $ while [ 1 ]; do make randconfig &> /dev/null; if [ $(grep "CONFIG_SL[OU]B=y" .config | wc -l) == 2 ]; then break; fi; done
> $ grep CONFIG_SL[OU]B=y .config
> CONFIG_SLUB=y
> CONFIG_SLOB=y
> 

Ping on this?
