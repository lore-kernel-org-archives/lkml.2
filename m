Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab1CWOjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:39:31 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33215 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab1CWOja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:39:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BmKxiEworWyzkQQEn1K0J7cJJPT0GP/3vlLPPOzsLKspJ6UmsjysIfygIZuKdf1ZXT
         yWUsA1xLcSuczOhT17wBsp3EqriWR7n8ld/aKLuGbkfnH4r8b+53SYjQ/TxtSBEkpD6k
         NbrKDAcM2iwtLMQUuc1XNP1bfAHESsMr9e50o=
MIME-Version: 1.0
In-Reply-To: <20110323142505.GD13315@redhat.com>
References: <AANLkTikEYDdL08=DdJ7fLR08r6sWDCHbNoOuGhxGhm7G@mail.gmail.com>
	<20110323142505.GD13315@redhat.com>
Date: Wed, 23 Mar 2011 15:39:28 +0100
Message-ID: <AANLkTi=EoPKcBE1miW_-RHgHTBCSDKJ1My=Z40rrhm1x@mail.gmail.com>
Subject: Re: Support for global block IO throttling?
From: Juerg Haefliger <juergh@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

>> Are there any plans to support global (per cgroup) IO throttling in
>> the near future? I'm in need of this and would gladly work on it if
>> nobody else is and if people think this is a useful feature. What I
>> envision is that one can specify the limits of individual devices in a
>> group but also specify the overall aggregate limit of the whole group.
>> I just started looking at the throttling code and haven't quite
>> figured it out yet so it might take me a bit to get up to speed.
>
> Hi Juerg,
>
> What's the use case? Why do you need global block IO throttling?

Resource management for guest VMs. I want to make sure a VM cannot
exceed a certain IO limit. If the VM does IOs to only one device, it
gets the full specified bandwidth to that single device but if the VM
talks to multiple devices, it only gets a fraction of the global
bandwidth per device, not exceeded the global limit.

...Juerg


> Thanks
> Vivek
>
