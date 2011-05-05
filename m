Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab1EESzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 14:55:10 -0400
Received: from smtp-out.google.com ([74.125.121.67]:35982 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1EESzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 14:55:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Gjze28pBww54Zy3YjUB0L3QyOX/0JLc+irD0vTnTCrQtXGNBU8Kgluozq75L+2vVMr
         67PUExfXBfFllY+2fj1g==
Date: Thu, 5 May 2011 11:55:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: J Freyensee <james_p_freyensee@linux.intel.com>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 1/4] export kernel call get_task_comm().
In-Reply-To: <1304614776.8860.51.camel@localhost>
Message-ID: <alpine.DEB.2.00.1105051154450.25277@chino.kir.corp.google.com>
References: <james_p_freyensee@linux.intel.com> <1303515150-1718-2-git-send-email-james_p_freyensee@linux.intel.com> <alpine.DEB.2.00.1104251357260.31884@chino.kir.corp.google.com> <1304614776.8860.51.camel@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, J Freyensee wrote:

> > Third time:
> > 
> > Acked-by: David Rientjes <rientjes@google.com>
> 
> Okay, so you want me to add an 'acked-by' next time on this patch in my
> patch-set series?
> 

That's the usual convention, yes.
