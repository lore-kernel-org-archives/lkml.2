Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0FTHXe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 03:23:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55789 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab0FTHXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 03:23:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=B4icihfk35seBwhjx4oE6w/8XLCctdrgh2P6ejtjJF62pH8Sof6dNokv1BJ6pMsBkT
         5eBiEYiGcadnM8otlvz0RRgdaUDcDTpdrFI7UprnFYDcg8nh4nM39tzTfUnOMQK+71lW
         ++nuKKSrARou0pU1QC+gx+k3zE0jsOHZb1Ccs=
Message-ID: <4C1DC1F0.7040609@gmail.com>
Date: Sun, 20 Jun 2010 09:23:28 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1rc2-2.2 Thunderbird/3.1
MIME-Version: 1.0
To: Suresh Rajashekara <suresh.raj+linuxomap@gmail.com>
CC: linux-omap@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: wait_for_completion_interruptible does not wait !!
References: <AANLkTikPOcNZk5ISX2WDHSmsPDw_a5_3Ic3owAbO4o0y@mail.gmail.com>
In-Reply-To: <AANLkTikPOcNZk5ISX2WDHSmsPDw_a5_3Ic3owAbO4o0y@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2010 08:52 AM, Suresh Rajashekara wrote:
> The ioctl waits on a completion variable (using
> wait_for_completion_interruptible).
...
> I tried wait_for_completion instead, but now the kernel refuses to suspend.

Do you check return value of wait_for_completion_interruptible and
return its value if nonzero?

We need the code to comment, otherwise it's hard to say.

-- 
js
