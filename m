Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab1FBLgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 07:36:01 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57374 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab1FBLf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XvXjvNir6aS29mVpbI2Rtn2inT6+1IlK+FAWELePtvQpeKFNpfxZP+E3ySoROnJEAC
         AlhRlc1ssMPEzAFFgJcwVjQe5s772ApfjtfclX1C5yZOuaRni9zoTPJXDOp2ceq0AM/8
         LsoyN1k8xppyMhdpH8gg4QLH93Lv04nB/RykA=
Message-ID: <4DE7759C.2090300@gmail.com>
Date: Thu, 02 Jun 2011 13:35:56 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH 2/2] xhci: Do not issue device reset when device
 is not setup
References: <1306963670-6344-1-git-send-email-m.b.lankhorst@gmail.com> <1306963670-6344-2-git-send-email-m.b.lankhorst@gmail.com> <20110601221722.GB17429@kroah.com> <20110601224205.GC13079@xanatos> <4DE6C4EE.8020807@gmail.com> <20110601233201.GA25067@xanatos>
In-Reply-To: <20110601233201.GA25067@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah,

Op 02-06-11 01:32, Sarah Sharp schreef:
>> I do think it needs inclusion in stable though, since it fixes the
>> xhci controller that so far never worked for me, although the earliest
>> kernel I tested on was v2.6.33.$x-rt$y. Didn't test the patch though,
>> but iirc the failure mode wasn't any different.
> Ok, but do these two patches fix the problem you're seeing on the Etron
> xHCI host controller on 2.6.39 or 3.0?
>
> Sarah Sharp
Yeah, I tested on linus' rc tree and 2.6.39, no longer have 33-rtX, but I suppose I can test there too. There seem to be a few regressions though that adds a few kernel oopses I'm hitting in sound in 3.0rc1, which I haven't isolated yet, but the xhci controller itself works. Also on works on 2.6.39.

~Maarten
