Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab1FOQCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:02:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63926 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab1FOQCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:02:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=U/ZgJZVuaa4dUfsxtwMhxKZ2NGqaRflLhV5znS7bjRK+IXMeLKyXz1ntnc4wbvo3+z
         D6RPJik0NxJl8TVUw2woMNmB6JmrniNExg/cS7TS8vHtQ1+YrcgJpki/6wtyVL82kBhM
         n8mLLkwQTtsH08W9AyqZgIya0bwqYW/oyNF0Q=
Message-ID: <4DF8D788.4050105@gmail.com>
Date: Wed, 15 Jun 2011 18:02:16 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Chris Mason <chris.mason@oracle.com>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: Remove all sysfs entries
References: <4DF86FFF.5000406@gmail.com> <20110615103431.GA15127@carfax.org.uk>
In-Reply-To: <20110615103431.GA15127@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 15-06-11 12:34, Hugo Mills schreef:
> On Wed, Jun 15, 2011 at 10:40:31AM +0200, Maarten Lankhorst wrote:
>> Seems that currently none of the sysfs are created any more, so just
>> remove sysfs support entirely.
>>
>> Fixes compiling warnings in 3.0rc3
>    I would actually like to retain sysfs support -- the current
> entries may not be used (or useful, or in the right place, or even
> visible these days), but there's plenty of things that could and
> should go in sysfs from btrfs.
>
>    So, please do remove the unwanted/unused file entries, but could
> you leave the sysfs file itself, and the (limited) bits that create
> the btrfs subdir? Otherwise, I'm going to be putting it all back in
> this weekend when I get the time to revisit Goffredo's old sysfs
> patch...
Currently sysfs.c is just 2 function calls, rest is unused, so I'll wait then.

Will in_sysfs in struct btrfs_root be used again? Currently it's not
used but only assigned zero.

~Maarten
