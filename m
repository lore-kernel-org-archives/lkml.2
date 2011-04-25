Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab1DYU5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:57:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18792 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab1DYU5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:57:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Mx62l+iYxB0ohDHiFD/kKb2axha2Xq1XEDzBtR9wqi58liO4RMop5sFOEg8apreLlx
         8kXjOz/gzFgHL61Yx/wg==
Date: Mon, 25 Apr 2011 13:57:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: james_p_freyensee@linux.intel.com
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 1/4] export kernel call get_task_comm().
In-Reply-To: <1303515150-1718-2-git-send-email-james_p_freyensee@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1104251357260.31884@chino.kir.corp.google.com>
References: <james_p_freyensee@linux.intel.com> <1303515150-1718-2-git-send-email-james_p_freyensee@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Apr 2011, james_p_freyensee@linux.intel.com wrote:

> From: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> This allows drivers who call this function to be compiled modularly.
> Otherwise, a driver who is interested in this type of functionality
> has to implement their own get_task_comm() call, causing code
> duplication in the Linux source tree.
> 
> Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>

Third time:

Acked-by: David Rientjes <rientjes@google.com>
