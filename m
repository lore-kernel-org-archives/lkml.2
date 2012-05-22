Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab2EVTvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:51:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39559 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab2EVTvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:51:43 -0400
Message-ID: <4FBBEE49.2020806@landley.net>
Date: Tue, 22 May 2012 14:51:37 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: add max_addr boot option
References: <4FBB3A23.50102@cn.fujitsu.com>
In-Reply-To: <4FBB3A23.50102@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 02:02 AM, Wen Congyang wrote:
> If we only want to use node0, we can specify the max_addr. The boot
> option "mem=" can do the same thing now. But the boot option "mem="
> means the total memory used by the system. If we tell the user
> that the boot option "mem=" can do this, it will confuse the user.
> So we need an new boot option "max_addr" on x86 platform.

I didn't follow that reasoning at all.  Care to try again?

(mem= can do this, but telling users that would confuse them?  What?)

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
