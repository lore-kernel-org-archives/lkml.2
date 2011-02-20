Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab1BTBvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 20:51:37 -0500
Received: from smtp-out.google.com ([74.125.121.67]:4104 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab1BTBvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 20:51:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=udW3rBui6BX4Iem/hDOHM49QS/Zwv1LgKX22UP21m6lm3ZdujW2a2YPfJfN3qZs5dk
         B9tzFYb+WqMAcIAXU4uA==
Date: Sat, 19 Feb 2011 17:51:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Travis <travis@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] printk: Break out printk_time
In-Reply-To: <20110219024705.979810372@gulag1.americas.sgi.com>
Message-ID: <alpine.DEB.2.00.1102191732120.27722@chino.kir.corp.google.com>
References: <20110219024705.308511527@gulag1.americas.sgi.com> <20110219024705.979810372@gulag1.americas.sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011, Mike Travis wrote:

> Clean up printk_time by making it a separate function.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>

Acked-by: David Rientjes <rientjes@google.com>
