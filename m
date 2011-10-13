Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab1JMBYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 21:24:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56731 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1JMBYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 21:24:08 -0400
MIME-Version: 1.0
In-Reply-To: <13498.1318467461@turing-police.cc.vt.edu>
References: <CAKYAXd9v_wFg2RQ_R+fYyCJnCbnuMs_VECujOen1GUSGXo3rHw@mail.gmail.com>
	<13498.1318467461@turing-police.cc.vt.edu>
Date: Thu, 13 Oct 2011 10:24:06 +0900
Message-ID: <CAKYAXd--8=MkpXi0H4-nGF1vYQF42aL+OEjysg86gw83uyrefQ@mail.gmail.com>
Subject: Re: RFC : fat : default errors use FAT_ERRORS_CONT instead of FAT_ERRORS_RO.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/13  <Valdis.Kletnieks@vt.edu>:
> On Thu, 13 Oct 2011 09:24:52 +0900, NamJae Jeon said:
>
>> It said windows fat provide a chance that continuously access
>> partition except corrupted file.
>
> It also gives you a chance to make things worse by continuing to write to the
> device.  If you force it RO at the first sign of trouble, maybe you lose a few
> blocks of one file.  If you keep writing to it, creating new files, erasing
> files, and so on, pretty soon your corrupted filesystem is even more corrupted.
There is no journal feature in FAT. it means FAT is corrupted well in
unexpected status.
Can you explain specifically what error will happen in case of keep writing ?
I think that MS consider also about this. maybe they think that
keeping access is better than changing RO type by one file is
corrupted.
>
>> I suggest that the default errors of linux fat use FAT_ERRORS_CONT
>> instead of FAT_ERRORS_RO.
>
> And what user benefit does that give?  If you keep going, they won't
> realize their device is corrupted, and won't have any reason to *fix* the
> filesystem.
for example, FAT is RW filesystem. and it is corrupted well by
unexpected status.
If so, user can not write FAT filesystem anytime while using linux
FAT.  there is no mehod except they should directly remount fat
parittion. well known linux user can do it only.
>
