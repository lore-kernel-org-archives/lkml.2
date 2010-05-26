Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab0EZUDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:03:46 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49797 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab0EZUDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:03:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LMioeeL0Pzgot2AqqroSm7gwKy91T0F+UPj6xGeegCJrMs6qSdM8fCfSE6islKxxIe
         DD0GgSVRAoyglzDstdjJjTAKYz8GIi6T0J4YhmE4QIDpwigZBSslo/0fm97/BMZpqpUk
         w82M/PZARi3eTTL49YgH1K4aAoA5GzCZqaWS0=
MIME-Version: 1.0
In-Reply-To: <20100526215606.2a747c61@schatten.dmk.lab>
References: <20100526171106.0e44a736@schatten.dmk.lab>
	<alpine.LFD.2.00.1005261829540.2995@localhost.localdomain>
	<20100526190204.5efe4d59@lxorguk.ukuu.org.uk>
	<20100526215606.2a747c61@schatten.dmk.lab>
Date: Wed, 26 May 2010 22:03:37 +0200
Message-ID: <AANLkTil3OdarNjeIuzWqM59x4ysFqJrMeiUZzceC_r7P@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Vitaly Wool <vitalywool@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 9:56 PM, Florian Mickler <florian@mickler.org> wrote:

> Your approach definitely sounds better than the current solution.
> What about mapping suspend blocker functionality later on, when this
> interface exists, on to this new approach and deprecating it?

What about coming back after some while with the appropriate solution
when it's ready instead of stubbornly pushing crap?

~Vitaly
