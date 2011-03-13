Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab1CMTAj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 15:00:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55160 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab1CMTAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 15:00:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GgiVfovRQjGe+tW7iC3LCRPVtxKK/lwY1n9VKfRkKIR3StwHzh7d8GcwIE1d8VkQyR
         Sp5TnKTnuIkkxbKcaTGdI82ZOV2tGEI2Cuxg4WFcXWTgSmHLLigiaaQWuczfE+oTVHNK
         LLFclyIh96laQ/wYjB6k1Ym8zbqLTfmcIDF6k=
MIME-Version: 1.0
In-Reply-To: <20110311223119.GA31049@kroah.com>
References: <1299724988-25351-1-git-send-email-a.beregalov@gmail.com>
	<1299724988-25351-2-git-send-email-a.beregalov@gmail.com>
	<20110311223119.GA31049@kroah.com>
Date: Sun, 13 Mar 2011 22:00:37 +0300
Message-ID: <AANLkTimKX0fceVHRSS5CU59F-2RnQbHqQR8pyJXQiBhB@mail.gmail.com>
Subject: Re: [PATCH next 2/6] staging: bcm: fix memory leaks
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 March 2011 01:31, Greg KH <greg@kroah.com> wrote:
> On Thu, Mar 10, 2011 at 05:43:04AM +0300, Alexander Beregalov wrote:
>> Free resources before exit.
>
> Next time, test your patches before sending them out.  This one breaks
> the build so I've dropped all of the patches in this series.  Please fix
> them, test them (by at the very _least_ building them) and then resend
> them.

Sorry for that, I have sent them again.
