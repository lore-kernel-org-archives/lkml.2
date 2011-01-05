Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab1AEKFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 05:05:35 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44072 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1AEKFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 05:05:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aMs+kdcarKgS6/JgwQWAVUDmsHUb/aE/u3vceNQqaaoFV4YsFfOGyudafb/FOypclS
         ZRIlimsNvQQyajGnblXXxqBtamt2VuvE6nsiN+xKR22SJgIJaq0aezKpMbTEd0Jj6k8m
         e037B/fK83QJ8oarSLkxC+0r/Sx+xbKVW9pvo=
MIME-Version: 1.0
In-Reply-To: <1294208410-4772-1-git-send-email-fernando.lugo@ti.com>
References: <1294208410-4772-1-git-send-email-fernando.lugo@ti.com>
Date: Wed, 5 Jan 2011 12:05:31 +0200
Message-ID: <AANLkTimYymY2vqCg3J_0KNiwSpF3FQL32FP=CE27BTvG@mail.gmail.com>
Subject: Re: [PATCH] staging: tidspbridge - configure full L1 MMU range
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Fernando Guzman Lugo <fernando.lugo@ti.com>
Cc: omar.ramirez@ti.com, gregkh@suse.de, rene.sapiens@ti.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 5, 2011 at 8:20 AM, Fernando Guzman Lugo
<fernando.lugo@ti.com> wrote:
> Otherwise a virtual address beyond of the L1 size is used,
> the MMU hardware will look into a memory that does not belong to
> L1 translation tables. IOW; the MMU would allow to access any
> memory, configured or not.
>
> Reported-by: Felipe Contreras <felipe.contreras@nokia.com>
> Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
> Signed-off-by: Felipe Contreras <felipe.contreras@nokia.com>

People rarely use ' - ' in the commit summary:
% git log --oneline -1000 | grep -e ' - ' | wc -l
32

Which means about only 3%. If you do the same on
drivers/staging/tidspbridge, you'll see that the only commits that
have that are from you.

staging: tidspbridge: configure full L1 MMU range

Other than that, I think this is is a critical bugfix, and should be
applied ASAP.

Cheers.

-- 
Felipe Contreras
