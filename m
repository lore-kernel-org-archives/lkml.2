Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1DED3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 23:29:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:31427 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab1DED3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 23:29:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=DOoOGH4OQGrcKdux5iC5dtOTRnAod55h9gNoZQreO+61/cLl4PV4rCv1DFxXJajGdE
         DTJYY0FYA3imW9T6pAvA==
Date: Mon, 4 Apr 2011 20:29:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Florian Mickler <florian@mickler.org>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, numa_64: remove unused variable
In-Reply-To: <1301843624-22364-1-git-send-email-florian@mickler.org>
Message-ID: <alpine.DEB.2.00.1104042029300.12570@chino.kir.corp.google.com>
References: <1301843624-22364-1-git-send-email-florian@mickler.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Apr 2011, Florian Mickler wrote:

> In case !CONFIG_ACPI_NUMA and !CONFIG_AMD_NUMA gcc emits a warning about
> the unused variable ret.
> 
> As that variable is in fact not needed I choose to remove it.
> 
> Signed-off-by: Florian Mickler <florian@mickler.org>

Acked-by: David Rientjes <rientjes@google.com>
