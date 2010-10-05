Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab0JEScH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:32:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55376 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0JEScF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:32:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=bFa4mItSJwyPAnlpCk+doz6MFiO41614HL/nMKRX/1V1TqWeHD2Zvg/3z7uPTeTjRP
         YiNV2q/mQ0mGK1m01JAA==
Date: Tue, 5 Oct 2010 11:31:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrea Righi <arighi@develer.com>
cc: Greg Thelen <gthelen@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 08/10] memcg: add cgroupfs interface to memcg dirty
 limits
In-Reply-To: <20101005091836.GA1698@linux.develer.com>
Message-ID: <alpine.DEB.2.00.1010051131290.11568@chino.kir.corp.google.com>
References: <1286175485-30643-1-git-send-email-gthelen@google.com> <1286175485-30643-9-git-send-email-gthelen@google.com> <20101005161340.9bb7382e.kamezawa.hiroyu@jp.fujitsu.com> <xr93r5g5w0uc.fsf@ninji.mtv.corp.google.com>
 <20101005091836.GA1698@linux.develer.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Oct 2010, Andrea Righi wrote:

> mmh... looking at the code it seems the same behaviour, but in
> Documentation/sysctl/vm.txt we say a different thing (i.e., for
> dirty_bytes):
> 
> "If dirty_bytes is written, dirty_ratio becomes a function of its value
> (dirty_bytes / the amount of dirtyable system memory)."
> 
> However, in dirty_bytes_handler()/dirty_ratio_handler() we actually set
> the counterpart value as 0.
> 
> I think we should clarify the documentation.
> 
> Signed-off-by: Andrea Righi <arighi@develer.com>

Acked-by: David Rientjes <rientjes@google.com>

Thanks for cc'ing me on this, Andrea.
