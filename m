Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab1ECM7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 08:59:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51999 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1ECM7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 08:59:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b/j0++6G//jc2La9NPM/wc9GG8e01QUC6tO4lEIhSgtFPb45JY8oApgoTiOh9hEeFf
         UFi5OiCsC7Y2CECfU8pnaGOwoViGR2mRJK8YBt64kaNCDwGCy9SntW8E1Qk6j9bjCVDh
         2r+Ave51Ycyawf9gwEobVx5TFMYqQkJ7JKol8=
Date: Tue, 3 May 2011 14:59:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 2/4] perf: Add persistent event facilities
Message-ID: <20110503125929.GB1730@nowhere>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-3-git-send-email-bp@amd64.org>
 <20110503064046.GD7751@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503064046.GD7751@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 08:40:46AM +0200, Ingo Molnar wrote:
> [ kernel/hw_breakpoint.c could possibly move into kernel/events/hw_breakpoint.c 
>   file as well - if Frederic acks it. ]

Makes sense yeah.

Thanks.

> 
> Thanks,
> 
> 	Ingo
