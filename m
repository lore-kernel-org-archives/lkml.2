Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab1IMFj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 01:39:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34609 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab1IMFj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 01:39:27 -0400
MIME-Version: 1.0
In-Reply-To: <20110913053007.GA21628@adam-station.nay.redhat.com>
References: <CAOwGe_yrRjq8Mqfcrm1P9bTYmPCA=qhNBxide10_w5ceR6wkDg@mail.gmail.com>
	<20110913053007.GA21628@adam-station.nay.redhat.com>
Date: Tue, 13 Sep 2011 01:39:26 -0400
Message-ID: <CAOwGe_wqZKE70iCT0sOGvi1Qn=zkrjppc8aGO_8gWaLRmAyvrw@mail.gmail.com>
Subject: Re: maintenance time and git error
From: esmaeil mirzaee <esmaeil.debian@gmail.com>
To: esmaeil mirzaee <esmaeil.debian@gmail.com>,
        kernelnewbies <kernelnewbies@kernelnewbies.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for reply
On Tue, Sep 13, 2011 at 1:30 AM, Adam Lee <adam8157@gmail.com> wrote:
> On Tue, Sep 13, 2011 at 01:22:05AM -0400, esmaeil mirzaee wrote:
>> Hi
>> does anyone know when the maintaining of the web page www.kernel.org
>> will be finish?
>> and when I try this "git clone
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux2.6.git
>> linux
>>
>> I got below error
>> "Initialized empty Git repository in /home/esmaeil/fixbug/krl/linux/.git/"
>> "fatal: Unable to look up git.kernel.org (port 9418) (Name or service
>> not known)"
>>
>
> It will be back in few days.
>
> If you wanna get updated, you can:
unfortunetly I don't want update it, This is my first time and I wanna get it.
and I try below but I think because I don't have the primary package
I got below error
> $ git remote add github git://github.com/torvalds/linux.git
fatal: Not a git repository (or any of the parent directories): .git
> $ git fetch github
fatal: Not a git repository (or any of the parent directories): .git
> $ git checkout -b github github/master
fatal: Not a git repository (or any of the parent directories): .git
> and you will get a branch named "github" with github remote.
> --
> Regards,
>        Adam Lee
>        --------------------------------------------------
>        E-mail: adam8157@gmail.com
>        Website: http://www.adam8157.info
>        --------------------------------------------------
>



-- 
Best
Esmaeil
https://sites.google.com/site/esmaeilmirzaee
