Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab1CaQf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:35:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55209 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1CaQf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:35:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jjDS4WQOyl7/uPQtyQIRKHKrzuWPK9p0+Sa6vrfotzUNccQxLiYo22LzTGOH2Lezt9
         P6COvB4SjxdgYJSX1cNM6zyCEMuEJO2uXfev/gy9M7QdJf+AmDlFZuTKZGvILE+n9Rck
         X63aqX2Q11loQsuD7UIzMOQQFQLqZbBFYFURk=
Date: Thu, 31 Mar 2011 18:35:52 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: Re: [PATCH 3/3] signal, ptrace: Fix delayed CONTINUED notification
 when ptraced
Message-ID: <20110331163552.GG3385@htj.dyndns.org>
References: <20110329144603.GA29865@htj.dyndns.org>
 <20110329144648.GB29865@htj.dyndns.org>
 <20110329144710.GC29865@htj.dyndns.org>
 <20110330192918.GA14861@redhat.com>
 <20110331072942.GB3385@htj.dyndns.org>
 <20110331151549.GA8458@redhat.com>
 <20110331163441.GF3385@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331163441.GF3385@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small correction.

On Thu, Mar 31, 2011 at 06:34:41PM +0200, Tejun Heo wrote:
> * Interruptible sleeps won't be disturbed on SIGCONT generation, which
                                 ^
				 spuriously
>   is a visible behavior change, but, I agree, this is more of a bug
>   fix.

-- 
tejun
