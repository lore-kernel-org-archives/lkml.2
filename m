Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab0L3L3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 06:29:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38453 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab0L3L3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 06:29:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kg6Ag2lKx7SNxh8DPtz/PYGwOvvI71amDrB2qjgxUmwpI0HJBbsYjbFHabl2lWURqH
         ix+gsOWhLkA2G4CaTHWRo2aEaMCDx4oj3XJns10EYBBwwjayQCfYbH9OBLbZNpevTU25
         0IgnQCgQhbSpxuBTiTY3Kixiw2U/6oV01IiUM=
Date: Thu, 30 Dec 2010 12:29:33 +0100
From: Tejun Heo <htejun@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: x86: Use this_cpu_has for thermal_interrupt
Message-ID: <20101230112933.GB18831@htj.dyndns.org>
References: <4D07A7CB.7010205@zytor.com>
 <4D07A95C.7030703@kernel.org>
 <4D0814AF.7080209@zytor.com>
 <4D08ECEF.3040909@kernel.org>
 <4D08EE57.8010602@zytor.com>
 <4D08EF4E.8070403@kernel.org>
 <4D0A3AF2.50508@gmail.com>
 <alpine.DEB.2.00.1012161212130.21588@router.home>
 <4D0CD4C6.5010309@gmail.com>
 <4D0FFB33.8020309@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0FFB33.8020309@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 04:56:19PM -0800, H. Peter Anvin wrote:
> On 12/18/2010 07:35 AM, Tejun Heo wrote:
> > On 12/16/2010 07:13 PM, Christoph Lameter wrote:
> >> It is more effective to use a segment prefix instead of calculating the
> >> address of the current cpu area amd then testing flags.
> >>
> >> Signed-off-by: Christoph Lameter <cl@linux.com>
> > 
> > For this and the other x86 patch.
> > 
> > Acked-by: Tejun Heo <tj@kernel.org>
> > 
> > I suppose these two x86 patches and the gameport one would go through
> > the x86 tree, right?
> > 
> 
> Yes, as long as I can get a stable base to pull into -tip.

I suppose I should take the two x86 and the gameport patches here into
percpu tree with your ACKs too.  Would that be okay with you?

Thanks.

-- 
tejun
