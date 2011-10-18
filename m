Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab1JRB3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 21:29:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:40511 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab1JRB3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 21:29:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=WRnbYt1+8UgF11H/UAVxQm5I74JXltlB2/mTD3bYYbWOmmXmAgiseunK5C0+vlBS1
	RD5kwkt8Wwr71pv0uno1w==
Date: Mon, 17 Oct 2011 18:28:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Josh Boyer <jwboyer@redhat.com>
cc: Greg Kroah-Hartman <greg@kroah.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] Update email address for stable patch submission
In-Reply-To: <20111018011638.GQ1165@zod.bos.redhat.com>
Message-ID: <alpine.DEB.2.00.1110171826450.13515@chino.kir.corp.google.com>
References: <20111018011638.GQ1165@zod.bos.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Josh Boyer wrote:

> The stable@kernel.org email address has been replaced with the
> stable@vger.kernel.org mailing list.  Change the stable kernel rules to
> reference the new list instead of the semi-defunct email alias.
> 
> CC: <stable@kernel.org>
> CC: <stable@vger.kernel.org>
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> 

Hmm, is stable@vger.kernel.org a replacement for stable@kernel.org or is 
it just temporary until kernel.org is fully back to life?
