Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1A0NOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:14:04 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37164 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab1A0NOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:14:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gKT2XfvvEkVY/KYE4NY1jm2FKB2cmitSV1mvseGwAQrdgwfUakhxq6pX48iCt2iKyk
         Zrm5ttDiKgm9tDcIHcB/3MUHiiAccJkTEyCG3wMZsMuO3tQKwbevtm+zAjnWQMjSY3dr
         Cxhq8lDrQZEAzxlchT6W4Nc8+6+awyCHgqhkc=
Date: Thu, 27 Jan 2011 14:13:56 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/7] clone: kill CLONE_STOPPED
Message-ID: <20110127131356.GA24925@htj.dyndns.org>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
 <1293199257-11255-2-git-send-email-tj@kernel.org>
 <20110117221705.C2E88180996@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110117221705.C2E88180996@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Roland.

On Mon, Jan 17, 2011 at 02:17:05PM -0800, Roland McGrath wrote:
> This is already stale as of commit 43bb40c.  Probably this whole series
> needs a new iteration on the current tree.  I hope we can hash out these
> into mergeable state pretty soon.

I dropped the first patch but all other patches seem to apply without
any change.

Thanks.

-- 
tejun
