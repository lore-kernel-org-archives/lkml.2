Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab1C1IWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 04:22:11 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59505 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1C1IWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 04:22:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=tbUoTeexIWjF+f88TuQCPreXgYf+ODCvdJREBzIfCzqynKf/zbYbI3TwaIBfu7Yh+j
         Vt77eehJtg+/Arhai+dMxftMZ2+F0bg8RwBmFdZ3RewZ2umAD+fdw988uO6SbNXb6WTO
         E68eNIKuzggZDw2KAWE/CJCDuP1sqMJXd8+kQ=
MIME-Version: 1.0
In-Reply-To: <20110326200419.GR21838@one.firstfloor.org>
References: <1300914043-2297-1-git-send-email-abogani@kernel.org>
	<1300914043-2297-3-git-send-email-abogani@kernel.org>
	<m27hbov7hq.fsf@firstfloor.org>
	<8739mblr2n.fsf@rustcorp.com.au>
	<20110325154118.GN21838@one.firstfloor.org>
	<AANLkTinW4GA094Yz94Y0qTEJvjOmRe4_C+5yc7_VcKM3@mail.gmail.com>
	<20110325194946.GQ21838@one.firstfloor.org>
	<AANLkTinYY0vRzVHKqaZghiK=SvFUAVbM5s3Hf6H9C5Pv@mail.gmail.com>
	<20110326200419.GR21838@one.firstfloor.org>
Date: Mon, 28 Mar 2011 10:22:07 +0200
X-Google-Sender-Auth: YGsUegSQhB3teNUMvuuMWjzNhps
Message-ID: <AANLkTin_PfbjMuye6J3dD7VrF3PYPhfA3up-+vuaBk-R@mail.gmail.com>
Subject: Re: [PATCH 2/2] Replace the linear search with a binary search for
 locate the symbols
From: Alessio Igor Bogani <abogani@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Kleen,

2011/3/26 Andi Kleen <andi@firstfloor.org>:
>> I have felt sure to have sorted both: indeed the linker sorts symbols
>> *before* it writes down their addresses (and not after). But I could
>> have made a mistake, obviously.
>
> I was refering to the address the symbol points to, not the address of
> the ksymtab entry.

I'm very confused.

My patches don't change nothing else but ksymtab* and kcrctab*
entries. My intentions were to leave actual symbols completely
unchanged.

Ciao,
Alessio
