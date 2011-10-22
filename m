Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1JVHTm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 03:19:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab1JVHTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 03:19:41 -0400
Date: Sat, 22 Oct 2011 03:19:37 -0400 (EDT)
From: David Airlie <airlied@redhat.com>
To: Robert Hancock <hancockrwd@gmail.com>
cc: Dave Jones <davej@redhat.com>, airlied@redhat.com,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [DRM] Lower the severity of the radeon lockup messages.
In-Reply-To: <4EA26DF9.8040903@gmail.com>
Message-ID: <alpine.LRH.2.00.1110220317580.30600@kibblesnbits.boston.devel.redhat.com>
References: <20111021165101.GA27960@redhat.com> <4EA26DF9.8040903@gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> At the risk of sounding obvious, wouldn't it be better to enhance the driver 
> to dump out more useful debugging info in this case rather than just 
> suppressing the ABRT report?

In theory yes, in practice that is non-trivial. The amount of data you 
need to keep track off is in the MBs, it can range from any previous GPU 
command stream sent to the GPU, to the contents of any of the vertex 
buffers etc.

the problem with GPU lockups is you don't notice them until after you've 
queued up a tonne more stuff since they are such deep pipelines.

Dave.
