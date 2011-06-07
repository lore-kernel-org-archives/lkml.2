Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab1FGUqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:46:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32964 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab1FGUqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:46:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mrZNptdY4ng0QvkhKovdlHy9LOtIiXq1RDdWe18UapNhczAFfonx5S+4jcAUySRACR
         zBgvokHmVZuGEt0dGQOphV/i4OIlnY3BAmn9iWUIPZr9ouGONRcc3Ncx7Jq3+l14T3uP
         M6XE3eTlPUqzoLU3NeFNCN9eAqh7ZimU1pIsw=
Date: Wed, 8 Jun 2011 00:46:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] x86: Make copy_from_user_nmi() a library function
Message-ID: <20110607204608.GA1754@sun>
References: <COL116-W380DF5357514E3CC28BB66A38F0@phx.gbl>
 <4DD5046F.3000807@us.ibm.com>
 <4DD53BC8.2010208@hotmail.com>
 <20110607105259.GE20052@erda.amd.com>
 <4DEE2F09.6090803@hotmail.com>
 <20110607171822.GI20052@erda.amd.com>
 <20110607172413.GJ20052@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607172413.GJ20052@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 07:24:13PM +0200, Robert Richter wrote:
... (unrelated a bit) ...
> +
> +		offset = addr & (PAGE_SIZE - 1);
> +		size = min(PAGE_SIZE - offset, n - len);
> +
...

Robert, would not offset = addr & ~PAGE_MASK be somehow more
readable? Just a thought.

	Cyrill
