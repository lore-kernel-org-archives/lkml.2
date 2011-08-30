Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab1H3Gvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 02:51:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23387 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1H3Gvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 02:51:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=XxkR5EdELv4fp6mEbwfW53MqGoEv2frmAIrBGh6z3JCIV1GZfdYByCxI/Rqjtq6AV
	2VbbTwhn40TkPKYjaoguA==
Date: Mon, 29 Aug 2011 23:51:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jason Liu <jason.hui@linaro.org>, Pekka Enberg <penberg@kernel.org>
cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] slub: doc: update the slabinfo.c file path
In-Reply-To: <1314687126-23252-1-git-send-email-jason.hui@linaro.org>
Message-ID: <alpine.DEB.2.00.1108292350360.16398@chino.kir.corp.google.com>
References: <1314687126-23252-1-git-send-email-jason.hui@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011, Jason Liu wrote:

> slabinfo.c has been moved from Documentaion/vm/ to
> tools/slub/ by commit:0d24db337e6d81c0c620ab65cc6947bd6553f742
> 
> Update the slub.txt doc to reflect this change too.
> 
> Signed-off-by: Jason Liu <jason.hui@linaro.org>
> Cc: Christoph Lameter <cl@linux-foundation.org>

Adding Pekka Enberg <penberg@kernel.org> who maintains the slab subsystem.

Acked-by: David Rientjes <rientjes@google.com>
