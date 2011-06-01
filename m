Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab1FAWlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:41:37 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57736 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab1FAWlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:41:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=a30oDWHHNDN/G8ZKEbYmJpatVZ7EVaKeyyOZ37imoHFGkw129Z9DFZi2Htijs/HZpG
         PRjYHVIKGPAdffe/1Wt3i3jO7aiIyj2MtMJ+T6VxhzV6pv/QxG/VmovHGg+5qroYrmEY
         zicSo7peky6evwzSCkPje1pzh3hsQXzTBXoWI=
MIME-Version: 1.0
In-Reply-To: <20110601211506.GA16121@suse.de>
References: <BANLkTi=6-sGL9QJbyK34kCPbaPVOREE1QA@mail.gmail.com>
	<20110601211506.GA16121@suse.de>
Date: Wed, 1 Jun 2011 15:33:21 -0700
Message-ID: <BANLkTi=MF2ApN4yRvFOr2sM3PbrnRGPtng@mail.gmail.com>
Subject: Re: Long-term stable versions in linux-2.6-stable.git?
From: Bryan Hundven <bryanhundven@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 2:15 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Jun 01, 2011 at 10:38:35AM -0700, Bryan Hundven wrote:
>> Hello,
>>
>> I was wondering if there are plans to include the long-term stable
>> versions in the /pub/scm/linux/kernel/git/stable/linux-2.6-stable.git
>> repository?
>>
>> I'm not subscribed to lkml, please cc on response.
>
> It's been discussed numerous times in the past, the thing is, I don't
> control the script that does this so I have no control over it, sorry.

Ok. The reason I ask is that it is painful to merge changes from
2.6.35.13 back to 2.6.35.9, then forward to >2.6.36, although I guess
I will have to live with it.

If you don't mind me asking; who controls the script that does this?

Thanks for the response!

> greg k-h
>
