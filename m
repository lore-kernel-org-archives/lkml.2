Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab1A0FsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 00:48:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51486 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1A0FsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 00:48:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Edrim26ebCfVgOsqZB27XwYBu4KAhLVV8IUmOYaYLGtXiE7vx9jua34ar470OmAcye
         2r/+kIf5+dChu/H8WcF/rvx90daImRSXK2oBHAvoAQjTvmq1O+F8s4a3PrS91SCxP5T7
         H2KxuvRpIQrsZQa3bWmmGRCle1dO6zCO3KIdo=
MIME-Version: 1.0
In-Reply-To: <ihqo2g$qmm$1@dough.gmane.org>
References: <76a04784-ace0-4be7-9dd7-a16e91803dc8@i25g2000prd.googlegroups.com>
 <ihqo2g$qmm$1@dough.gmane.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 Jan 2011 21:47:49 -0800
Message-ID: <AANLkTi=AfSj5hL-Z8M4=X6=9XuVak8RG3Jq65=YZOS9O@mail.gmail.com>
Subject: Re: Tup with Linux kernel modules
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, tup-users <tup-users@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 7:16 PM, WANG Cong <xiyou.wangcong@gmail.com> wrote:
> On Wed, 26 Jan 2011 11:59:17 -0800, mcgrof wrote:
>
>> Just curious if anyone has used tup to build the Linux kernel.
>>
>> http://gittup.org/tup/make_vs_tup.html
>>
>> Looks sexy.
>
> We have to convert Makefile to Tupfile, don't we?

Yeah.

  Luis
