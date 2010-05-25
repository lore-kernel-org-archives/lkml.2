Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab0EYXJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 19:09:09 -0400
Received: from smtp-out.google.com ([74.125.121.35]:19378 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758801Ab0EYXJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 19:09:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=XzQJpwNybud0heFlrbzR4LKgGICPShpEimpgEcHXQ+pFSI7KSjtDNln86b0TARzA4
	Gcn90wupYIGDOgkAt5Zdw==
Date: Tue, 25 May 2010 16:08:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dan Carpenter <error27@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] mempolicy: ERR_PTR dereference in
 mpol_shared_policy_init()
In-Reply-To: <20100525215401.GA2506@bicker>
Message-ID: <alpine.DEB.2.00.1005251608440.10919@chino.kir.corp.google.com>
References: <20100525215401.GA2506@bicker>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010, Dan Carpenter wrote:

> The original code called mpol_put(new) while "new" was an ERR_PTR.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
