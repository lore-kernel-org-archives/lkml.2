Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab0H3Cml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 22:42:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64542 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab0H3Cmj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 22:42:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IfakRAqhaZ5XXOGJF2uijVU7eSuRGci1c0APtD5owTDxdhaNbcVdm0bVUC6x8umwWb
         i6c9cJZDZadlL2/WXsERFTHhqZG0RhjzsJoON0imUtPMnXC2FwyH+PEIofTdn2cemBbw
         kSfaQy1qXnbXuVUQOXm8eoQn+0TR2ySSfQMAk=
MIME-Version: 1.0
In-Reply-To: <1282936206-17288-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1282936206-17288-1-git-send-email-Kyle.D.Moffett@boeing.com>
Date: Sun, 29 Aug 2010 19:42:39 -0700
X-Google-Sender-Auth: UJOb0lFWNkPb46QhS69q97uSVLc
Message-ID: <AANLkTimr8-hZYtQyYTTPmvRaNr-upRtVdddtoRbRbQ_y@mail.gmail.com>
Subject: Re: [PATCH] e1000e: Intel 82571EB: Don't wait for MNG cycle on
 unmanaged chips
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, Kyle Moffett <kyle@moffetthome.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 12:10, Kyle Moffett <Kyle.D.Moffett@boeing.com> wrote:
> The Intel 82571EB chipset can be used in an unmanaged configuration as a
> fast dual-port Gig-E controller.  Unfortunately a board constructed that
> way would fail to correctly come up because the driver polls for the
> completion of a management cycle that will never occur.
>
> To resolve this problem, we disable the poll and error return on chips
> whose EEPROMs indicate no management.  As a protection against
> misconfigured chipsets, we still delay for the entire management poll
> timeout.
>
> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
> ---
>  drivers/net/e1000e/82571.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>

Thanks Kyle, I have added the patch to my queue.

-- 
Cheers,
Jeff
