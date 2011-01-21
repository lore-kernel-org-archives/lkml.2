Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab1AURsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:48:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47695 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab1AURsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:48:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jN8Q+XeL2CrrNO2Tx+FBwQza3PPdlyLOgy+fMEET3Ik3O6s6OuwRriMghSArn/fANe
         DmfgVG4nsmkZf+s8QJQqe5gcUy0EpjQKb9G/zGP/T83+VdrhVCzAkOSREIDDd5MfhYkU
         s7X3OnakCOSWLcLdLpSiZKoH+CUKHYFskts7g=
Date: Fri, 21 Jan 2011 18:48:17 +0100
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pekka Enbeerg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org
Subject: Re: x86: A fast way to check capabilities of the current cpu
Message-ID: <20110121174817.GM2832@htj.dyndns.org>
References: <alpine.DEB.2.00.1012151404070.21102@router.home>
 <20110121171133.GI2832@htj.dyndns.org>
 <alpine.DEB.2.00.1101211114530.15692@router.home>
 <20110121172836.GK2832@htj.dyndns.org>
 <alpine.DEB.2.00.1101211139330.15692@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101211139330.15692@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 11:46:04AM -0600, Christoph Lameter wrote:
> > Oh, you're right.  Sorry about that.  Can you please then add a
> > comment noting that the operation is x86 only?  Maybe prefix it with
> > x86_?
> 
> For a function defined in an specific include file and only used in arch
> specific code?

Hmm?  asm/percpu.h gets included by linux/percpu.h, so it would end up
in most .c files.

Thanks.

-- 
tejun
