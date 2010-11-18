Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab0KRNk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:40:27 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48750 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab0KRNk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:40:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ur2428wgX6G8RMhUeM3bl0uytNPMLCrKlcdlwtZLBMzNIDINMAIuJpugxxafiUA7Km
         K8Kb2p5dJSZBBmhgLDVSIg8ApE0Cb186exKSlQ49huxl3ce8+AZ8lanUVvmoHMxxHnc6
         dg9jKLQZgOBUCze15PPw6CWB4elZzGufp/fLM=
Date: Thu, 18 Nov 2010 21:43:24 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Will Newton <will.newton@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 1/2] uml: Safely iterate list of winch handlers in line
	driver.
Message-ID: <20101118134324.GA3800@hack>
References: <AANLkTi=xJb1LcGXeCcd_tJ+Q9vV5W4z3M-up_mrKeV9q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=xJb1LcGXeCcd_tJ+Q9vV5W4z3M-up_mrKeV9q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 05:44:28PM +0000, Will Newton wrote:
>unregister_winch should use list_for_each_safe, as it can
>potentially delete from the list.
>
>Signed-off-by: Will Newton <will.newton@gmail.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Andrew Morton

Thanks.
