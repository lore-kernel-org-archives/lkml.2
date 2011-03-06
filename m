Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1CFCoP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 21:44:15 -0500
Received: from smtp-out.google.com ([74.125.121.67]:27322 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab1CFCoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 21:44:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=lPvwCA85Ry97Ip5XmjAFdE/9euHtvNIMyE7Yzs/tT42nF0T0dCXXFrRZhGGT2GqXLn
         uovWGp+khA2oEzPYHhSw==
Date: Sat, 5 Mar 2011 18:44:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrey Vagin <avagin@openvz.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: skip zombie in OOM-killer
In-Reply-To: <1299286307-4386-1-git-send-email-avagin@openvz.org>
Message-ID: <alpine.DEB.2.00.1103051843490.8779@chino.kir.corp.google.com>
References: <1299286307-4386-1-git-send-email-avagin@openvz.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Mar 2011, Andrey Vagin wrote:

> When we check that task has flag TIF_MEMDIE, we forgot check that
> it has mm. A task may be zombie and a parent may wait a memor.
> 
> v2: Check that task doesn't have mm one time and skip it immediately
> 
> Signed-off-by: Andrey Vagin <avagin@openvz.org>

Acked-by: David Rientjes <rientjes@google.com>
