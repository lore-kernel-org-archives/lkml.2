Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab0ENJSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 05:18:12 -0400
Received: from smtp-out.google.com ([74.125.121.35]:11566 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab0ENJSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 05:18:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=l/l53YDo87SnBA70hRaobh/O3s5xVXsf8uQ8IOMXrDvAPIr++aqNt4QIJLIRA9tdo
	cPM3RNvSOH3GLmfd9kSAQ==
Date: Fri, 14 May 2010 02:17:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andreas Dilger <adilger@dilger.ca>
cc: linux-mm@kvack.org,
       "linux-kernel@vger.kernel.org Mailinglist" 
	<linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH 1/1] mm: add descriptive comment for TIF_MEMDIE
 declaration
In-Reply-To: <930863A4-0E91-4994-8EA0-E18361B0113D@dilger.ca>
Message-ID: <alpine.DEB.2.00.1005140217400.24388@chino.kir.corp.google.com>
References: <930863A4-0E91-4994-8EA0-E18361B0113D@dilger.ca>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010, Andreas Dilger wrote:

> From: Andreas Dilger <adilger@dilger.ca>
> 
> Add descriptive comment for TIF_MEMDIE task flag declaration.
> 

It would probably be better to say functionally what it does: gives oom 
killed tasks access to memory reserves.
