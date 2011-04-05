Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab1DEGDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 02:03:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45453 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab1DEGDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 02:03:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=x7AjBHl0qtT/idwNNTXbeDtgmgH7RTPO+qeBg0ZwsciCJbjqKQjWWUv2odUnQhPRDk
         0m0wo0wSKrkW99mwEGl7IsuMyzXtv5ua6GNVPdlI4ljA5F040RGkFNDKxlEodkujQEZE
         IUbCBLByvMZ0bO9yg2G4O+NraD/YntzTaD780=
Subject: Re: Re: X86_32: Got a kernel panic when poweroff
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "wanlong.gao" <wanlong.gao@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <201104051340535622833@gmail.com>
References: <201104050339475463862@gmail.com>
	 <201104051340535622833@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 08:02:57 +0200
Message-ID: <1301983377.3021.628.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 05 avril 2011 à 13:41 +0800, wanlong.gao a écrit :
> I pulled the linus' tree ,then it goes well .
> The issue is seems like you said ,unregister the syscore_ops
> But , can you tell me how did you know that ?

I analysed your crash and came to this conclusion.

(My local linux-2.6 copy did not had the fix, like yours)



