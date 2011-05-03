Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab1ECNTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 09:19:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47767 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab1ECNTy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 09:19:54 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTik=LX8RQEh1ouhSdFxUH+2oro9J6w@mail.gmail.com>
References: <20110503114353.30d1f949.sfr@canb.auug.org.au> <BANLkTik=LX8RQEh1ouhSdFxUH+2oro9J6w@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 3 May 2011 07:19:34 -0600
X-Google-Sender-Auth: 2d4FPiuS13CdQh4lZrjlC7VB1iA
Message-ID: <BANLkTikOBGCu70NrsFAa42w5M6O+dkHZnw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the 52xx-and-virtex tree with Linus' tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mundt <lethal@linux-sh.org>, Grant Likely <grant.likely@secretlab.ca>,
        linux-kernel@vger.kernel.org, Heiko Schocher <hs@denx.de>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 11:49 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>
> On May 2, 2011 7:43 PM, "Stephen Rothwell" <sfr@canb.auug.org.au> wrote:
>>
>> Hi Grant,
>>
>> Today's linux-next merge of the 52xx-and-virtex tree got a conflict in
>> drivers/video/sm501fb.c between commit e6a049807105 ("video, sm501: add
>> edid and commandline support") from Linus' tree and commit b6c19191c13e
>> ("video/sm501: add edid and commandline support") from the
>> 52xx-and-virtex tree.
>>
>> These are slightly different versions of the same patch.  I used the
>> version from the 52xx-and-virtex tree (that removed a use of
>> __devinitdata).
>>
>> Also, another between commit 4295f9bf74a8 ("video, sm501: add OF binding
>> to support SM501") from Linus' tree and commit 9d83d245a352
>> ("video/sm501: add OF binding to support SM501") from the 52xx-and-virtex
>> tree.
>>
>> Again, different versions of the same patch.  The former has a whole hunk
>> that appears to fix a memory leak.  So I used that.
>
> Okay, I'll probably drop those patches from my tree then... I'll investigate
> tomorrow.

Ah, I missed that Paul had picked them up.  Dropping from my tree.

g.
