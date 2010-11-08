Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab0KHOFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 09:05:54 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36720 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab0KHOFw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:05:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=oUESSuT1xOZt7yYm3n27hWzsuR9vrHi8cFIzPJd5nDxTHo8zneXRkLCJgePuWcWU/Y
         fKDShjzv1dsWhK/j4U7cGrnPDP/dSHag2dHcw74/SxVc1qDCDcIMESYmRUpSgyR8XZwD
         itIrMK/sH8TtJ/O7BHT2MbdglrVHJKhnb2TFk=
MIME-Version: 1.0
In-Reply-To: <4C0670E2.1090708@netservers.co.uk>
References: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com>
 <20100326160226.0159ac3b@lxorguk.ukuu.org.uk> <4BACE827.4070006@gmail.com>
 <20100326170428.6c1ad66c@lxorguk.ukuu.org.uk> <4BB31E00.8060204@netservers.co.uk>
 <20100529021624.GA2538@brick.ozlabs.ibm.com> <4C03E1CD.4000809@netservers.co.uk>
 <4C0670E2.1090708@netservers.co.uk>
From: Richard Hartmann <richih.mailinglist@gmail.com>
Date: Mon, 8 Nov 2010 15:05:30 +0100
Message-ID: <AANLkTi=GHmqeb=8rMZAnpqdKGbTEf2mRYhygX1aC2hyD@mail.gmail.com>
Subject: Re: [Patch] fix packet loss and massive ping spikes with PPP multi-link
To: Ben McKeegan <ben@netservers.co.uk>
Cc: Paul Mackerras <paulus@samba.org>, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        linux-kernel@vger.kernel.org, gabriele.paoloni@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 16:55, Ben McKeegan <ben@netservers.co.uk> wrote:

> Still working on this, updating the patch wasn't as trivial as I thought as
> it clashed with Gabriele Paoloni's ppp_mp_explode redesign.  However, while
> looking at this code I believe I have found a bug which might have been
> contributing to the poor performance the OP was experiencing.   For the case
> where channel speeds are unknown and there are more than 2 channels it would
> miscalculate the fragment sizes so they are not balanced on the channels.
>
> Patch for the bug to follow immediately.

Is there any update on this? It's been quite some time since you last updated
on this issue.


Thanks a lot,
Richard
