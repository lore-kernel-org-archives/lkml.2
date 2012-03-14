Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab2CNPuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 11:50:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38386 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab2CNPuQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 11:50:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120314154339.GB25000@redhat.com>
References: <CAC9WiBiZ9oOaDaYjow-ZryZ8i=7uLixTAfm48YKVpbwQfLfayQ@mail.gmail.com>
	<20120314154339.GB25000@redhat.com>
Date: Wed, 14 Mar 2012 16:50:14 +0100
Message-ID: <CAC9WiBgxrNBqRMx_2-FGcY1mGroi=mRxGV31idunkhUTwCNskg@mail.gmail.com>
Subject: Re: Getting oops with 3.2.10 when removing a SD card
From: Francis Moreau <francis.moro@gmail.com>
To: Dave Jones <davej@redhat.com>, Francis Moreau <francis.moro@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 4:43 PM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Mar 14, 2012 at 04:38:04PM +0100, Francis Moreau wrote:
>  > Hi,
>  >
>  > I'm getting this oops (pretty often) after writing to a SD card and
>  > removing the card.
>  >
>  > Could anyone have a look please ?
>
> Should be fixed by this patch that has been around for a while now.
>

Why isn't it mainlined then ?

Thanks
-- 
Francis
