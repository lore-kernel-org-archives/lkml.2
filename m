Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab2APX6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 18:58:19 -0500
Received: from mailout-eu.gmx.com ([213.165.64.42]:44422 "HELO
	mailout-eu.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750788Ab2APX6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 18:58:17 -0500
X-Authenticated: #50610217
X-Provags-ID: V01U2FsdGVkX18zsy9G7YYzZ1JXclB56sn0Sex2e5xf2CR0DJIqVZ
	HMMJH2L6rlnTTg
From: Martin Nyhus <martin.nyhus@gmx.com>
To: Jerome Glisse <j.glisse@gmail.com>
Subject: Re: [next] Null pointer dereference in nouveau_vm_map_sg
Date: Tue, 17 Jan 2012 00:57:50 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-next-20120116; KDE/4.6.5; x86_64; ; )
Cc: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <201201152231.08561.martin.nyhus@gmx.com> <20120116203059.GC4482@homer.localdomain>
In-Reply-To: <20120116203059.GC4482@homer.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201170057.51404.martin.nyhus@gmx.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16. January 2012 21:30:59 Jerome Glisse wrote:
> On Sun, Jan 15, 2012 at 10:31:08PM +0100, Martin Nyhus wrote:
> > In some cases mem will be null in nouveau_vm_map_sg, resulting in a crash
> > at drivers/gpu/drm/nouveau/nouveau_vm.c:84. It seems to be easy enough to
> > reproduce, so I can test patches if needed.
> How do you trigger this ?

Opening 10-15 high-res pictures in Firefox triggers it every time. Doing the 
same using Gimp does not, and neither does Firefox and lots of small images 
(eg. Google image search).

	Martin
