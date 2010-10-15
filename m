Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab0JOOMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:12:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32980 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab0JOOMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:12:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aMjqepfgX6OI37utX5cwuyybdMFFNVBBflzP3QLPD7tTffUTGdLAt6exlELNo9LlVj
         0eJ6Mas+nyLb4nv9ak2UiMq9CNq7KAgiAA7cOAbn48R4xfsQWFdNRUNL7JS+2HOibCPp
         xVEYIHIVQUYOCIsib1I/bFSBoZ0JLo3rtGgtA=
Date: Fri, 15 Oct 2010 16:04:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC][PATCH 7/7] perf: Optimize sw events
Message-ID: <20101015140437.GD5334@nowhere>
References: <20101014203404.222133139@chello.nl> <20101014203625.609332490@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014203625.609332490@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 10:34:11PM +0200, Peter Zijlstra wrote:
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>



Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


