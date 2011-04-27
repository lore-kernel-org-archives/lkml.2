Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab1D0KMC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:12:02 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53400 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab1D0KMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E53VvTcgcLcs2xWiulmMw2Rk4QOLW072kkz2ybO6wBJ9gsV1iyuzf4WAirZEGgXwvS
         jYK/oXejp6sZoygU8Un55Dza6tzCoqarfvpUxQVuED8Mzd54k2OTaD5RmM2Uo56hFhxO
         bgO1lImZsbDF+el6iP+0U7N5+PQWoMCiDGU2Y=
Date: Wed, 27 Apr 2011 12:11:56 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] signal: rename signandsets() to sigandnsets()
Message-ID: <20110427101156.GC31015@htj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
 <20110418173224.GA27918@redhat.com>
 <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
 <20110423175901.GA484@redhat.com>
 <20110426194822.GA8520@redhat.com>
 <20110426195018.GG8520@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426195018.GG8520@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 09:50:18PM +0200, Oleg Nesterov wrote:
> As Tejun and Linus pointed out, "nand" is the wrong name for "x & ~y",
> it should be "andn". Rename signandsets() as suggested.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
