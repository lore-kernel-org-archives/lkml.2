Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0FARE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 13:04:27 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43579 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab0FAREZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 13:04:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o7bPLmC7mvr5bivsmixd7gebUusZ0lRV8VrMDla19MG8xVhoyJu53KjlCA9Du/0aSh
         /2Yvu44JV96tJ/dYizqRTGlB6eYu1rHimrHZFKcGiDx4YR1zGEpTgtjZhXvYf/rYZ3n4
         2TGubbJ/vSABABrNj8EBMfz7WmAp4ZEXsiy0w=
MIME-Version: 1.0
In-Reply-To: <20100530104303.15864d35.sfr@canb.auug.org.au>
References: <20100528105719.a356ba4f.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.1005271807470.11382@i5.linux-foundation.org>
	<20100530104303.15864d35.sfr@canb.auug.org.au>
Date: Tue, 1 Jun 2010 10:04:25 -0700
Message-ID: <AANLkTinSRHyxGFKRnIlfUGbnLqIpZWLtq7ipYFH25wGW@mail.gmail.com>
Subject: Re: linux-next: build failure in Linus' tree
From: Tony Luck <tony.luck@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 5:43 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> So, is it reasonable for me to ask you to revert commit
> 0ac0c0d0f837c499afd02a802f9cf52d3027fa3b ("cpusets: randomize node rotor
> used in cpuset_mem_spread_node()")?  Reverting it won't break ia64 (since
> their fix was to just add code that would then be unreferenced).

If that's the way you go - then just revert commit
4ec37de89d8c758ee8115e0e64b3f994910789ee
too. I only put that in to get the ia64 build working
when 0ac0c0d went upstream.

-Tony
