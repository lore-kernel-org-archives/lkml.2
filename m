Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab1HPVqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 17:46:10 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:58817 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab1HPVqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 17:46:08 -0400
Date: Wed, 17 Aug 2011 00:43:52 +0300
From: Dan Carpenter <error27@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
        devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Akshay Joshi <me@akshayjoshi.com>, linux-kernel@vger.kernel.org,
        Karthigan Srinivasan <karthigan.srinivasan2@gmail.com>,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 4/9] Staging: Winbond: Convert C99 style comments in
 Winbond.
Message-ID: <20110816214352.GK26027@shale.localdomain>
References: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
 <1313454275-5604-4-git-send-email-me@akshayjoshi.com>
 <CA+XFjir3W3kqin1mL5W_OEduUTyUDADwH6pL=kaS=wHpP=KMeQ@mail.gmail.com>
 <CAOJsxLGqc6khjGQMA=b1BwTv_4pv4ZgkdjJrgtMbRwuNDrN_iA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOJsxLGqc6khjGQMA=b1BwTv_4pv4ZgkdjJrgtMbRwuNDrN_iA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 12:24:06AM +0300, Pekka Enberg wrote:
> 2011/8/16 Gábor Stefanik <netrolller.3d@gmail.com>:
> >> -
> >> -//====================================
> >> -// Internal variable for module
> >> -//====================================
> >> +/*============================================================================
> >> +/* wb35rx.h --
> >> +/*============================================================================
> >
> > I'm pretty sure this is not an accepted kernel comment style.
> 
> What's the problem? I think it's OK for this particular patch.

There are a five start open comment "/*" marks in a row that don't
have a matching close comment.

regards,
dan carpenter
