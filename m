Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab1D3MDN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 08:03:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61705 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab1D3MDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 08:03:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vdpLc0Nyho+DS++ZT5NgtJ1rPQxg/5lTxnQHcCd/GjwW6OjAOV8xOYFHopBSlwy6w+
         MdxsFnP2CulcKHWG2acGl633nGimfXUYaBzRvQBAPHygZEgGDWla0ON3SoHaCiDmqSd+
         ftotA9+0+6krYFpb0qEOpUS5ZLB7KBqprMl3k=
Date: Sat, 30 Apr 2011 14:03:07 +0200
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, rientjes@google.com, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/25] x86, NUMA: trivial cleanups
Message-ID: <20110430120307.GE29280@htj.dyndns.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
 <1304090924-8197-9-git-send-email-tj@kernel.org>
 <4DBAF498.40007@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBAF498.40007@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 10:25:44AM -0700, Yinghai Lu wrote:
> On 04/29/2011 08:28 AM, Tejun Heo wrote:
> > * Kill no longer used struct bootnode.
> > 
> > * Kill dangling declaration of pxm_to_nid() in numa_32.h.
> > 
> > * Make setup_node_bootmem() static.
> 
> first one and third one should appear in patches that I posted before.

Sorry, can't understand what you mean.  What are you trying to say?

-- 
tejun
