Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab0JRVPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:15:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33002 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab0JRVPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:15:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JTvpmDV0SsPrqfZYsVyZ6myyvZx7JxmHAFVi7Nt+3yOlLBQDYAiO8U9vBijTG3DvPx
         p11Q/Fv91yC06YJBufp/Fejf8mCOw3cc2hQRq/+gh6Dlo88m411qUYaBTFX7PnlkUbho
         osm6w5MXOBh5o9eqbj/Df5gxnSvBwyn1zax0Q=
Date: Mon, 18 Oct 2010 23:10:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] x86: Cleanup TIF value gaps in shift range
Message-ID: <20101018211028.GA5370@nowhere>
References: <1287434158-24362-1-git-send-regression-fweisbec@gmail.com> <4CBCB28A.9010602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBCB28A.9010602@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 01:48:10PM -0700, H. Peter Anvin wrote:
> On 10/18/2010 01:35 PM, Frederic Weisbecker wrote:
> > 9, 19 and 26 values are missing from the TIF shift range, probably
> > due to flags that were removed by the past. Now repack the range
> > so that we can quickly retrieve the remaining free shift slots.
> > 
> > But take care of keeping the seperation between high and low bits
> > as some masks are created on top of this boundary.
> > 
> 
> What is the point of this?  All it seems is that it would make stupid
> debugging mistakes possible because someone looks at the values from the
> wrong kernel.
> 
> Feel free to put comments in:
> 
> /* 9 - unused - was TIF_xxx */
> 
> ... but I think gratuitous compaction is a really bad idea.
> 
> Nacked-by: H. Peter Anvin <hpa@zytor.com>


I just felt the current state was messy. But I understand your reasons,
just forget those patches.

Thanks.

