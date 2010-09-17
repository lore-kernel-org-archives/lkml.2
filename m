Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab0IQRHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 13:07:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48502 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab0IQRHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 13:07:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CT7kZsVDQmB9UZMV56TNOrKMBCBgSFIQ9fV71fp800OCRvSabaLRtbdLgtn+ZIMuo/
         jEYyzJtc0MVDS+QnjRShtJOuQNmbBeMfsbpn4jR7uFJfFUenx9t97PilQBIKdJAOTgQt
         Jw0jwe6ZtFOdmQA5ZvgwUqYOcDi3dW3g/izjY=
MIME-Version: 1.0
In-Reply-To: <20100917175724.79c9b8db@lxorguk.ukuu.org.uk>
References: <AANLkTikrgooRh3tv+TCE-dNbwENcAss4EUnr4T4=Mgi6@mail.gmail.com>
	<20100917175724.79c9b8db@lxorguk.ukuu.org.uk>
Date: Sat, 18 Sep 2010 01:07:44 +0800
Message-ID: <AANLkTinFWTouTszRu46r88AyvMti-t5C-+TwdE8-XGYP@mail.gmail.com>
Subject: Re: What is happening to my harddisk?
From: Peter Teoh <htmldeveloper@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 12:57 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Ignoring those related to CD (sr devices), can someone please explain
>> to me what is happening, and what device does ata7 mapped to?
>
> Your CD drive appears to freaked.
>
You are right.   My CD drive has nothing inside, which is why I did
not suspect anything.   But now even after putting a CD inside, "k3b"
still cannot recognize the CD. Hm.......Thanks for the reply.


-- 
Regards,
Peter Teoh
