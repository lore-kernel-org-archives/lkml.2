Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab1F1AU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 20:20:57 -0400
Received: from smtp-out.google.com ([74.125.121.67]:23674 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab1F1ATn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 20:19:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=r6RXrfBk6xSc502JTYeIQ3Dg+3roUf231E/BoJAQTE99JV5sFzexydi7MyaAH01scb
         l/B+m6G/r9Ocotf0OiRg==
Date: Mon, 27 Jun 2011 17:19:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ben Greear <greearb@candelatech.com>
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/2] slub:  Add method to verify memory is not deleted.
In-Reply-To: <4E091670.9040405@candelatech.com>
Message-ID: <alpine.DEB.2.00.1106271718340.29910@chino.kir.corp.google.com>
References: <1309216631-31493-1-git-send-email-greearb@candelatech.com> <1309216631-31493-3-git-send-email-greearb@candelatech.com> <alpine.DEB.2.00.1106271622510.24211@chino.kir.corp.google.com> <4E091670.9040405@candelatech.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011, Ben Greear wrote:

> I saw a case where xprt was 0x6b6b6b6b.  I'm trying to figure out
> what freed it.

And echo 1 > /sys/kernel/slab/<cache>/store_user doesn't help?
