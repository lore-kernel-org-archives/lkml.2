Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab1AGGG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 01:06:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63874 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab1AGGG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 01:06:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dVkzL+J/NrNc+8eLB/X4aYxU1P5MSVt726A7HJqR9qm66aqtUp/P6l++eWvMHgkwiQ
         CxBoTBLzaIwA+3H7DCMJBjnn8HkldhQOOdEmBIeGijBcwOG7kG49B9mmTNVVeXXvZAQN
         V2yXtP/3jcnQJbkCS9lTBkFdkhH2nBS8PWlb0=
Date: Thu, 6 Jan 2011 22:06:19 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rakesh Iyer <riyer@nvidia.com>
Cc: "'Randy Dunlap'" <rdunlap@xenotime.net>, Jesper Juhl <jj@chaosbits.net>,
        "tsoni@codeaurora.org" <tsoni@codeaurora.org>,
        "shubhrajyoti@ti.com" <shubhrajyoti@ti.com>,
        "ccross@android.com" <ccross@android.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH v2] input: tegra-kbc - Add tegra keyboard driver
Message-ID: <20110107060618.GB29038@core.coreip.homeip.net>
References: <1294351512-17035-1-git-send-email-riyer@nvidia.com>
 <alpine.LNX.2.00.1101062311340.13988@swampdragon.chaosbits.net>
 <20110106142714.f823dea8.rdunlap@xenotime.net>
 <1FC56210173BB445BD77F608D6FB8D03165A008053@HQMAIL03.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FC56210173BB445BD77F608D6FB8D03165A008053@HQMAIL03.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 06:49:45PM -0800, Rakesh Iyer wrote:
> 
> Is having this check really an issue?  Can't input_free_device change
> in the future so that NULL as a parameter does cause undesirable
> side-effects?

No, it won't because changing it to crash on NULL pointers would be
really stupid.

Thanks.

-- 
Dmitry
