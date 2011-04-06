Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab1DFKOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 06:14:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53002 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab1DFKOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 06:14:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XS9u5K/QSPS9LvscR85jZBAtbyboWPmVbYCPrhh+rSKQ6jZP29FHgSSyNekcT69YQ+
         AiBY4JuMeAZNJjRXXzefF/zr+Jj6QKqLMjzb+DhU67yc4lCkTMXEk/sizH7qvhlyZWxF
         7I7sV6hUqs9Ah2K7JqvcQK1X22eeA71nOdfIw=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=yTfMiLvVtZTqQvxVhy7aFPdwSXQ@mail.gmail.com>
References: <201011181650.00152.roucaries.bastien@gmail.com>
	<AANLkTinp4=c9qmVyfocUk_ydJ3PV50b9UckNhJJNFsFm@mail.gmail.com>
	<AANLkTimYiRYZVXtxLBNeGcG=KVJTTiaGn+XGYP2Y=XMo@mail.gmail.com>
	<201103311704.40372.roucaries.bastien@gmail.com>
	<BANLkTikmtyyMes84rED5wpMxuN8kL91jEw@mail.gmail.com>
	<4D9B3C10.9060704@suse.com>
	<BANLkTi=XDzOcZsP+aKS_WQSRxT+N8XHBRQ@mail.gmail.com>
	<BANLkTi=yTfMiLvVtZTqQvxVhy7aFPdwSXQ@mail.gmail.com>
Date: Wed, 6 Apr 2011 12:14:11 +0200
Message-ID: <BANLkTi=KUMNWJZZBQSHK+WViy6BYv8+4dQ@mail.gmail.com>
Subject: Re: Reiserfs deadlock in 2.6.36
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 12:58 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 2011/4/5 Bastien ROUCARIES <roucaries.bastien@gmail.com>:
>> On Tue, Apr 5, 2011 at 5:58 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>>> -----BEGIN PGP SIGNED MESSAGE-----
>>> Hash: SHA1
>>>
>>> On 04/05/2011 09:30 AM, Bastien ROUCARIES wrote:
>>>> Ping ? You said on bugzilla it is related to acl but see nothing
>>>
>>> Yeah, I think it's related to the nesting not being quite right, but I
>>> need to look into it more. I've been unable to reproduce the problem
>>> locally.
>>
>> You could reproduce quite easilly using with a lot of git pull in
>> parallel (in a lot of different repo)... In less than one hours if you
>> have luck
>>
>> Bastien
>
> Ah. I'm going to try that.
> Can you perhaps send us your .config, in case it happens only on some
> specific set. And also your options passed to mount reiserfs in /etc/fstab ?

Config file is the same than previously
mount option are rw,nosuid,nodev,relatime,user_xattr,acl

Bastien

> Thanks.
>
