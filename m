Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2DPTrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:47:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48884 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab2DPTrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:47:19 -0400
Message-ID: <4F8C7741.5030008@landley.net>
Date: Mon, 16 Apr 2012 14:47:13 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: remove 'linux' from dontdiff file
References: <201204131552.03079.hartleys@visionengravers.com>
In-Reply-To: <201204131552.03079.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2012 05:52 PM, H Hartley Sweeten wrote:
> The linux entry in the dontdiff file causes the include/linux
> directory to be skipped.
>     
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> CC: Randy Dunlap <rdunlap@xenotime.net>

Acked-by: Rob Landley <rob@landley.net>

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
