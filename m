Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab0GWMIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:08:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55649 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0GWMIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:08:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=oWrgRFI6vqGPedP6JoI80paTSr1kX+VhXZ9vf2iu+NJmyWffI4neOxgQtZ9OPcbF/i
         c/diByYGISyYfNHkzh7tOxDskq0TVqzfoiu+XSA/hIBtmhnbFkC47ku+lAyVIpmhj/vl
         U4sROrMl5wBwxOjNk0DMJ4J4LZLwtNTSCR9ss=
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [RFC] tpm_tis: Fix subsequent suspend failures
Date: Fri, 23 Jul 2010 14:07:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc5-wl-default+; KDE/4.4.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        tpmdd-devel@lists.sourceforge.net,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, jmorris@namei.org,
        linux-kernel@vger.kernel.org
References: <201006091227.15729.helmut.schaa@googlemail.com> <5204AD54-F4BF-49A8-9168-3FCA112AAA2B@linux.vnet.ibm.com> <20100623130700.a032c373.akpm@linux-foundation.org>
In-Reply-To: <20100623130700.a032c373.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007231407.51605.helmut.schaa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Mittwoch 23 Juni 2010 schrieb Andrew Morton:
> On Wed, 23 Jun 2010 16:55:54 -0300
> Rajiv Andrade <srajiv@linux.vnet.ibm.com> wrote:
> 
> > > (top-posting repaired.  Please don't do that).
> > > 
> > > This wasn't a very good way to send a patch.  I edited the diff,
> > > reconstructed the patch and then assembled a decent-looking changelog. 
> > > I also changed your acked-by to the required signed-off-by, because you
> > > were on the patch's delivery path.
> > > 
> > > Pretty please: next time, prepare a proper mergeable patch with the
> > > correct attributions and signoffs?  Thanks.
> > 
> > Sure, sorry. I was just not certain if I could just resent Helmut's patch to LKML without messing with his authorship.
> 
> You can.  Put his "From:" line right at the top of the changelog and
> everyone's patch-receiving tools will honour that.  If the From: at the
> top of the changelog is absent, the tools will fall back to using the
> From: line in the mail headers.

This patch still didn't make it into mainline and it fixes a regression.
Rajiv, do you plan to resubmit the patch or did you expect it to go through
Andrew's tree?

Thanks,
Helmut
