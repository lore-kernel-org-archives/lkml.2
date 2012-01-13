Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab2AMMoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 07:44:22 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55250 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752910Ab2AMMoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 07:44:21 -0500
X-Sasl-enc: dQeEF2J1T2r/SuT/Azc2aN27Ep/58CFvW2LBegyc9d4DxGg6IAWfu19zHw 1326458660
Message-ID: <1326458657.2219.24.camel@perseus.themaw.net>
Subject: Re: autofs4 hung task
From: Ian Kent <raven@themaw.net>
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ftp.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jan 2012 20:44:17 +0800
In-Reply-To: <CAPM=9tzbgk=O6iTAM1Vp3SuZLkt7NnaMx0=+wbpW1x+sXk-3zA@mail.gmail.com>
References: <CAPM=9tzbgk=O6iTAM1Vp3SuZLkt7NnaMx0=+wbpW1x+sXk-3zA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-13 at 10:26 +0000, Dave Airlie wrote:
> Hi guys,
> 
> I booted Linus master kernel this morning (I was being brave and
> basing some fixes on it), however it hung on boot and the stuck task
> timer went off in autofs4 waiting on a mutex.
> 
> I got a picture with my phone attached.

Thanks Dave, an obvious mistake I missed in a recent commit by the look
of it.

Ian


