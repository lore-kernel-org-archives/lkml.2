Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab1IMQjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 12:39:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62591 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab1IMQjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 12:39:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6467"; a="118055166"
Date: Tue, 13 Sep 2011 11:39:43 -0500
From: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Janitor: Typo in stack debug code
Message-ID: <20110913163943.GC23759@codeaurora.org>
References: <20110913162023.GA23759@codeaurora.org>
 <CAL4Wiioh69CYAnbJnCuQM8cs19eWCsXF8p_rwAswBWQfe5+rWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL4Wiioh69CYAnbJnCuQM8cs19eWCsXF8p_rwAswBWQfe5+rWQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 06:31:14PM +0200, Eric Dumazet wrote:
> 2011/9/13 Linas Vepstas (Code Aurora) <linas@codeaurora.org>:
> >
> > In the debug routine check_stack_usage(), free stack space is counted
> > in units of (unsigned long), not bytes.  Make this clear when printing.
> 
> Thats not true, everything is fine.

You are correct, I was wrong. Wow. Monday morning fuziness on a Tues.
My apologies.

--linas

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
