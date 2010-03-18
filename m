Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab0CRQvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 12:51:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:57320 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0CRQvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 12:51:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=SY+eySKZGyvhyL492lAC9bR7tMvMWVBOWbkwzYYzTr4nf00eZu3M37Up1/k1+7Av6c
         CpCMqelMXOe6BgsBYcJPdWGDny9hpeVmE2TBbu9gKUmjL0aaXdvOW6+5yt9qcykvkAii
         is6G5l93TQzVNPx8F1eZaQJGhAfXo0mEBxrzY=
MIME-Version: 1.0
In-Reply-To: <4BA256FE.5080501@codemonkey.ws>
References: <20100318085607.GB2157@elte.hu> <4BA20EB8.60707@redhat.com>
	 <20100318114821.GB13168@elte.hu> <4BA21B09.6060706@redhat.com>
	 <20100318130047.GA7424@elte.hu> <4BA23FE1.5050402@codemonkey.ws>
	 <20100318151737.GA2875@elte.hu> <4BA250BF.80704@codemonkey.ws>
	 <20100318162853.GB447@elte.hu> <4BA256FE.5080501@codemonkey.ws>
Date: Thu, 18 Mar 2010 18:51:16 +0200
X-Google-Sender-Auth: f8364888b5df8982
Message-ID: <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single 
	project
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Fr?d?ric Weisbecker" <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 6:38 PM, Anthony Liguori <anthony@codemonkey.ws> wrote:
>>>> There are all kernel space projects, going through Xorg would be a
>>>> horrible waste of performance for full-screen virtualization. It's fine
>>>> for the windowed or networked case (and good as a compatibility
>>>> fallback), but very much not fine for local desktop use.
>>
>> For the full-screen case (which is a very common mode of using a guest OS
>> on the desktop) there's not much of window management needed. You need to
>> save/restore as you switch in/out.
>
> I don't think I've ever used full-screen mode with my VMs and I use
> virtualization on a daily basis.
>
> We hear very infrequently from users using full screen mode.

Sorry for getting slightly off-topic but I find the above statement interesting.

I don't use virtualization on daily basis but a working, fully
integrated full-screen model with VirtualBox was the only reason I
bothered to give VMs a second chance. From my point of view, the user
experience of earlier versions (e.g. Parallels) was just too painful
to live with.

/me crawls back to his hole now...

                        Pekka
