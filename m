Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0LJHn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 02:43:59 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:64456 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab0LJHn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 02:43:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tbVgWB4Hdi5o3BmJxK3J9HqmJozWpk9CBjy0pt/eb/fU7zCkORPWfYXv1rlgwkcERs
         NDqoxGlZLMDDwrZ+VgCWg2YrAYBXDSDsdyWJNIC8zs8vYHc03uht3zkxKAtAUKYPO07x
         YQ4AIgP8xUmLygphnAnI750xeWds55uBdcNLE=
Date: Thu, 9 Dec 2010 23:43:51 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Interface and MT_TOOL documentation updates
Message-ID: <20101210074351.GC21009@core.coreip.homeip.net>
References: <1291929732-5989-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291929732-5989-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 10:22:12PM +0100, Henrik Rydberg wrote:
> The recent input-mt interface changes together with
> recent discussions about pen and touch and support
> for legacy multitouch pads suggest that the documentation
> on MT tool types be expanded. This patch adds references
> to the new interface, and adds a section for MT_TOOL types,
> in particular documenting the use of MT_TOOL_ENVELOPE.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>


The explanation of the new types makes sense to me... Do you think we
could add some comments directly to input.h?


> @@ -247,21 +249,34 @@ ABS_MT_TOOL_TYPE
>  The type of approaching tool. A lot of kernel drivers cannot distinguish
>  between different tool types, such as a finger or a pen. In such cases, the
>  event should be omitted. The protocol currently supports MT_TOOL_FINGER and

s/and/,/

> -MT_TOOL_PEN and MT_TOOL_ENVELOPE [2].
> +MT_TOOL_PEN and MT_TOOL_ENVELOPE [2]. For type B devices, this event is
> +handled by input core, via the input_mt interface.
> +

Thanks.

-- 
Dmitry
