Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab1FJMp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:45:28 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64994 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab1FJMpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:45:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=PDwWPcFYImnUpu9vCh4BnIndirEr19KsyiJQsi6kkZ4kW1Rv0vWbS27hEjoj87nwyw
         zIjJwEwuYpFmBMqMlmeOV40ymrNrp8KGRmZZOxMz+5tg2nSWMv2X+9L3tkLQvXZSHmfp
         BsGbOli7YPB2+3a5wP8H/uqbLn36e3I8JXs4Y=
MIME-Version: 1.0
In-Reply-To: <4DF2053F.6080502@itwm.fraunhofer.de>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
 <20110608153208.dc705cda.akpm@linux-foundation.org> <20110609115934.3c53f78f@notabene.brown>
 <20110608205233.ebfedc4d.akpm@linux-foundation.org> <20110609134947.GD13242@shadowen.org>
 <20110609123220.6afb9d0f.akpm@linux-foundation.org> <4DF2053F.6080502@itwm.fraunhofer.de>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Fri, 10 Jun 2011 14:45:03 +0200
X-Google-Sender-Auth: -7su_3IvZ4Axb1cC1k7hdxxLXf8
Message-ID: <BANLkTimc20TDKiZDpSsnJSr-utOrU1oRdw@mail.gmail.com>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, NeilBrown <neilb@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, nbd@openwrt.org, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 June 2011 13:51, Bernd Schubert <bernd.schubert@itwm.fraunhofer.de> wrote:
> On 06/09/2011 09:32 PM, Andrew Morton wrote:
>>
>> On Thu, 9 Jun 2011 14:49:47 +0100
>> Andy Whitcroft<apw@canonical.com>  wrote:
>>
>>> On Wed, Jun 08, 2011 at 08:52:33PM -0700, Andrew Morton wrote:
>>>
>>> The problem with the userspace alternative is that it does not work. I
>>> tried to run my live CD on top of unionfs-fuse and the filesystem
>>> would fail intermittently leading to random errors during boot.
>>
>>
>> If the implementation is slow or buggy then the appropriate action is
>> to speed it up and to fix the bugs, so these are just non-arguments,
>> IMO.
>
> Exactly. It is rather sad that people never bothered to file bug reports
> about slow performance issues. I'm one of the upstream authors of
> unionfs-fuse and also use it on my own for live-USB sticks and NFS-booted
> systems and do not have such problems.

The issue is that while I can pause the boot process in initramfs and
the filesystem appears all well and running if I run init off the
filesystem some filesystem operations just fail at random leading to
files seemingly missing intermittently and the live CD failing to
boot.

I realize this is tremendously useful information but that's all I can
say about the issue which is why I did not bother to report it
anywhere.

I used whatever was packaged in Debian Squeeze.

Thanks

Michal
