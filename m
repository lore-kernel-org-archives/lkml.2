Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab0EJGdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 02:33:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61846 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab0EJGdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 02:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nGNtRjJs3ogMSPE6v9OFCrH0HqIfFdv9W4uFWT4KqojGqAR8sc+QHSjRJ9yOyzXlxd
         LmMTprkEkOpVwv2pAOLAUJDsXIHMf5Oz2qDaGAlS4b/UPBb3rWq6Qe+c/Gkwqx58Nv5U
         Ob2FfBpfpRc/C19pTHs+dYX+IDbY1xIUwKU8Y=
Message-ID: <4BE7A8A8.40204@gmail.com>
Date: Mon, 10 May 2010 09:33:12 +0300
From: roma1390 <roma1390@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] nfs kernel server causes: kernel BUG at include/linux/module.h:386!
References: <4BE257EF.9050904@gmail.com> <20100506060326.GA20846@kroah.com> <4BE3BCDF.4080604@gmail.com> <20100507165606.GA795@kroah.com>
In-Reply-To: <20100507165606.GA795@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> If you can't test it, if I add that commit id to .27, I don't see how
> that would help you out at all, right?

There isn't a big like to test on production. But rescent that same bug was 
triggered on testing in virtual machine. So theoretically this is only matter 
of human time resource.

There is hope that commit to 2.26.x will be taken by debian, and updated 
kernel will be propagated by debian update system.

> Can you poke the debian developers about this?
Case are reported[1] to debian and waiting for any progress.

1. http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=532561#21
