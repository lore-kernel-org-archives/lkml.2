Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0HSSQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 14:16:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65265 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab0HSSQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 14:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bCkH97cHMObBPGI8Dw+fMiVy84OYiE/dN9zuC/th6RNeuleegEuPeRhIOyDI8POIER
         X4h4moys77gAepBkWdHXPUxMHAeT9lvdROcDmbVT0qJzD/jDeAYA0pbx85rc6iXc/bWU
         W4C56gSys7DRb5nPBmbGphEped+xEBn8yavjU=
MIME-Version: 1.0
In-Reply-To: <20100819174638.GC2672@tuxdriver.com>
References: <20100819174638.GC2672@tuxdriver.com>
Date: Thu, 19 Aug 2010 20:16:17 +0200
Message-ID: <AANLkTi=QmVT_qJb6O7eDE9-VM5CZBa3ueR9njFps5oMs@mail.gmail.com>
Subject: Re: pull request: wireless-2.6 2010-08-19
From: Jan III Sobieski <jan3sobi3ski@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2010/8/19 John W. Linville <linville@tuxdriver.com>:
> Dave,
>
> This collection of fixes intended for 2.6.36 includes a few that look
> bigger than they really are.  The one from Joe Perches corrects a number
> of inadvertant upper->lower case conversion from an earlier patch
> already in 2.6.36.

I wonder when the madness linked to the trivial patches will end up.

Next time, please tell "no more trivial patches". No more stupid
removal of white spaces, no more useless
"IamAwesomeKernelHacker->i_am_awesome_kernel_hacker"
conversions/masturbations etc.

Thanks in advance,
J

-- 
Jan III Sobieski
