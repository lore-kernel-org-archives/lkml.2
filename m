Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0FXFuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 01:50:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35244 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab0FXFue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 01:50:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HGnYiLSDrljbBWTbGtPZjmSVb1oxcOhSRvxNZbXwZt5BmHw0M2mcD53Syazbsps15O
         XE6J/+92NM3VRxelDdgBaPsYSkuLU3WXv1+Ul+XFcpIUYTpFluEJpl0Llb8yFCCumYD4
         F+q/Qy9bTm/dsCFlhD5W2dAL60NfXV63p7TLM=
Subject: Re: 2.6.35-rc3 -- kernel BUG at mm/vmalloc.c:216! - invalid
 opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <AANLkTilNYZryQNy037Eiaw1WxBN_WLLUdY6gxk3KaBBS@mail.gmail.com>
References: <AANLkTimYUy0tCvGHf_Qtz0tUG7XVms9i3MOz03m28Jin@mail.gmail.com>
	 <AANLkTilNYZryQNy037Eiaw1WxBN_WLLUdY6gxk3KaBBS@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 07:50:28 +0200
Message-ID: <1277358628.3471.1149.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 juin 2010 à 13:30 +0800, Xiaotian Feng a écrit :
> On Thu, Jun 24, 2010 at 1:11 PM, Miles Lane <miles.lane@gmail.com> wrote:
> > I ran:  "find /sys | xargs head"
> >
> 
> It goes from "cat /sys/devices/system/cpu/cpux/crash_notes" ...

Thanks, but could you please avoid sending huge mails, if you only add
on line each round ?



