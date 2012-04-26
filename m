Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab2DZNWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 09:22:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58585 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2DZNWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 09:22:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120426231203.b1fbc86e26b2c9b426b81a64@canb.auug.org.au>
References: <CAB=NE6W85xRWajvuMm3MnAXebwU-+=6H+Za+W6F-fiVTH_VpXQ@mail.gmail.com>
 <20120426231203.b1fbc86e26b2c9b426b81a64@canb.auug.org.au>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 26 Apr 2012 06:22:23 -0700
X-Google-Sender-Auth: 2j0pS_BGFk65PVG0YPG38cK1qiE
Message-ID: <CAB=NE6Vz3pQ-HetgGeB64R7Ld1d41TDaq4cZzP_KO+bTU0jcmQ@mail.gmail.com>
Subject: Re: Tags for successful compilations of linux-next
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 6:12 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Luis,
>
> On Thu, 26 Apr 2012 05:32:13 -0700 "Luis R. Rodriguez" <mcgrof@frijolero.org> wrote:
>>
>> As a daily consumer of linux-next I'm wondering if there are tags that
>> perhaps could be introduced to annotate when a linux-next tag itself
>> did successfully compile across all the tests you have for linux-next
>> each day. As a consumer of linux-next, for example, I could just take
>> those tags to ensure my own snapshots do compile as well. Checking
>> with you to see if this is worth it for an extra tag to annotate these
>> somehow.
>
> Linux-next has never built for all the test builds we do :-(

Indeed :(

> However,
> (almost) every linux-next release does build for the following:
>
> PowerPC: ppc64_defconfig, allnoconfig, (64bit) allnoconfig, ppc44x_defconfig,
>         allyesconfig (fails in the final link)
> X86_64: allmodconfig

I just ran into two tags where drivers/net/ failed with allmodconfig
but in my tests case for x86, and hence this e-mail. Typically I
actually don't run into issues, but this got me thinking about
possible tags to annotate successful build tests.

> i386: defconfig

And now this make sense :)

> sparc: 32 and 64 bit defconfig

That's pretty impressive that all test build tests are done though and
that typically they all do work for most tags, thanks!

  Luis
