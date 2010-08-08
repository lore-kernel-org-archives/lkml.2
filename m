Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab0HHCGY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 22:06:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56283 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab0HHCGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 22:06:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=a5YWv1Gba8L21O00TNkevopRU+CA0c72LvJbiN/cLFlnGVn85bNNLjhQkQtRzLbED0
         JvEV33t6TCuO9nY8ZPLxUjIdoFw6yYP7jLYvQckEDDF+GPkb9h9/lcKTF9+LYyEGvkIZ
         Od+FDNMycUVhPDtRJEso5CfCOH6AkTc+B5/h0=
MIME-Version: 1.0
In-Reply-To: <7c1104f5f4e78fa90e45850239a2484b6e224b0d.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de> 
	<7c1104f5f4e78fa90e45850239a2484b6e224b0d.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 7 Aug 2010 22:05:58 -0400
Message-ID: <AANLkTi=FsQ9mRBNCyRJv+M=dK1-j0wZt3N=gWMackhax@mail.gmail.com>
Subject: Re: [PATCH 1/6] arch/blackfin: Remove config HIGHMEM
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Robin Getz <robin.getz@analog.com>, Tejun Heo <tj@kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 12:00, Christian Dietrich wrote:
> CONFIG_HIGHMEM can't be selected in blackfin, therefore all references
> to it can be removed from the arch/blackfin.

while currently we dont support highmem (as our current parts max out
at 512MiB), this should be feasible in the not-so-far future, in which
case we will have highmem support added.  so i'm inclined to leave it
be as in a highmem world, this is the code we'd want.  thanks though.
-mike
