Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab0LGSpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 13:45:03 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:33990 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab0LGSpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 13:45:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nwTVupfid8cP36KKj6AJu74lXzFK25KqvpmezzqCIime4bJYHJEiN91vdgI73jaKsR
         0tj8AnWY8+OiR2uWo5WsLEKNY3R63gYToJ2sPROHFCwu2Py7+F5fEFueJN4reKqGTp81
         b2LpCkahIYsAp1c1/QDht+pNoHlkNyyMNOYaA=
Date: Tue, 7 Dec 2010 20:44:53 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] media: fix em28xx build, needs interrupt.h
Message-ID: <20101207184453.GA30998@core2.telecom.by>
References: <20101206140055.34289498.sfr@canb.auug.org.au>
 <AANLkTi=XkxnHZGTEsrrRmPGQePitzb=akyS99_Qd6ROy@mail.gmail.com>
 <20101207103815.26054c38.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101207103815.26054c38.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 10:38:15AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> drivers/media/video/em28xx/em28xx-vbi.c:49: error: implicit declaration of function 'in_interrupt'

> +#include <linux/interrupt.h>

It's defined in hardirq.h.
