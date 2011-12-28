Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1L1RNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 12:13:16 -0500
Received: from senator.holtmann.net ([87.106.208.187]:56437 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1L1RNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 12:13:15 -0500
Message-ID: <1325092345.1965.283.camel@aeonflux>
Subject: Re: [bluetooth] linux-3.x regression (bisected)
From: Marcel Holtmann <marcel@holtmann.org>
To: Rene Herman <rene.herman@gmail.com>
Cc: Andre Guedes <andre.guedes@openbossa.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Date: Wed, 28 Dec 2011 09:12:25 -0800
In-Reply-To: <4EFB49E2.7010404@gmail.com>
References: <4EF3BACA.1080405@gmail.com>
	 <CACJA=fVezGGcgAtbzG=+ouWq0PiHbgXN1YPwL+VDUphWS7wnrw@mail.gmail.com>
	 <4EFA1EB8.9090005@gmail.com> <20111227203008.GA13870@joana>
	 <4EFA447C.3030906@gmail.com> <20111228012248.GC13870@joana>
	 <20111228012850.GD13870@joana> <4EFA7696.6060506@gmail.com>
	 <20111228155225.GA23292@joana> <4EFB49E2.7010404@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rene,

> > I think this patch can do handling, let's see what others think.
> 
> I can confirm that this works for me.
> 
> Might it be useful to specify the currently observed crap dongle (ie, 
> USB 1131:1004) in the changelog or comment? That way, if the handling 
> ever changes in the manner that David suggests, maybe this specific 
> dongle will find its way into the list immediately.
> 
> But... works for me as is.

the patch is wrong. It just fixes a symptom and not the problem. See my
other email.

Regards

Marcel


