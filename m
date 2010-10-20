Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab0JTXZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 19:25:46 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43906 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab0JTXZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 19:25:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CeFcbOp7T9zODzKHsOo6q35tLBXSCTT/sqJlt2GnmIAAuKiIAUBk5Njp4w7CSJqaib
         3ACRhmZqIsZCNZOgPHuBQ8lIO6iQQIivrpx0NmOIy/clD9705Nhubc7kkmIPkmUL9aYY
         DRyz7p7bBcAGuR9PCJakDB9FcraxoYo2I7IfI=
MIME-Version: 1.0
In-Reply-To: <20101020161547.0c9d95cc.akpm@linux-foundation.org>
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
	<AANLkTikapE3RaVVFS3yBSGmCkMGUvfZECJq5eOmayWhZ@mail.gmail.com>
	<4CA4D61C.2010909@gmail.com>
	<4CA4E76E.1050602@gmail.com>
	<20101004161600.8cdf4e0c.akpm@linux-foundation.org>
	<AANLkTimmQmQU4fE9ku_wc8x_dPEfnjgOHWSM18O0=coa@mail.gmail.com>
	<4CBF6602.3070801@gmail.com>
	<20101020161547.0c9d95cc.akpm@linux-foundation.org>
Date: Thu, 21 Oct 2010 01:25:44 +0200
Message-ID: <AANLkTinrXm7of1eSM=D0qin92MR2Qd+5DZgu7eTLjzCt@mail.gmail.com>
Subject: Re: [PATCH] Removal of duplicate includes from many files
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/21 Andrew Morton <akpm@linux-foundation.org>:
> The patch was space-stuffed by your email client and hence did not
> apply.

Bad thunderbird...

I'll try to fix it

>  I fixed it up.
>
> Many of these changes are already in linux-next.  I kept the changes
> which aren't in linux-next and verified that none of those changes were
> removing duplications which were already removed in linux-next.
>

Ok, thanks!

P.S. Next patches I will try to send through relevant trees

-- 
Slawa!
N.P.S.

Les fleurs du mal unfold
Comme les fleurs du mal
Dark demons of my soul
Un amour fatal
