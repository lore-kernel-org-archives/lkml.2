Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1FGLzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 07:55:54 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:50958 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1FGLzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 07:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=pqMcDYdTe1TVZZ+OwTeb4rVsYhuozMRaYiZsApgexFwkIcT5nrcDs+h7jD3l2QG2D9
         5XB4jp/Qf4ked4cFNAwiuvUtSyDicG/0XB/Q2RMIKohSAZGH+/6CZELkac8Mb4TbdfQf
         vGmSwXisA2kmnM1DSjcMRFgiv+VSOTi6bcyuY=
MIME-Version: 1.0
In-Reply-To: <201106070943.21004@zmi.at>
References: <BANLkTinX_BO94CdQsdmj=atFc-typqr0xg@mail.gmail.com>
 <BANLkTi=y2V4ZUyP02p_r_scqdSbprjbLsQ@mail.gmail.com> <201106070943.21004@zmi.at>
From: Drunkard Zhang <gongfan193@gmail.com>
Date: Tue, 7 Jun 2011 15:56:30 +0800
Message-ID: <BANLkTikrmbe9X3Weyb8ikhn1RX_Tn_NuAg@mail.gmail.com>
Subject: Re: bug in xfs: can't recovery metadata log
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/7 Michael Monnerie <michael.monnerie@is.it-management.at>:
> On Dienstag, 7. Juni 2011 Drunkard Zhang wrote:
>> With 2.6.39.1 too, output not the same thing.
>
> I'm not a developer, but have you tries xfs_repair -n ? As you crashed,
> probably the xfs log is damaged, needing a "xfs_repair -L", but wait for
> a more competent answer before you do this.
>
Oops, I already did "xfs_repair -L", successed. It's in production
environment, didn't have too much time to figure out why :-(
