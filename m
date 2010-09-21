Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab0IUKMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 06:12:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58876 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab0IUKMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 06:12:38 -0400
Message-ID: <f0da51fd10b5b6b99ca1b3cdaf924a11.squirrel@www.firstfloor.org>
In-Reply-To: <Wn2eLj_6KZG.A.sGH.ZE7lMB@chimera>
References: <1fwtoy8sG5H.A.veG.9D7lMB@chimera>
    <Wn2eLj_6KZG.A.sGH.ZE7lMB@chimera>
Date: Tue, 21 Sep 2010 12:12:37 +0200
Subject: Re: [Bug #18332] [regression] *ERROR* timed out waiting for
 FORCE_DETECT in 36rc3 on i915
From: "Andi Kleen" <andi@firstfloor.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Kernel Testers List" <kernel-testers@vger.kernel.org>,
        "Maciej Rutecki" <maciej.rutecki@gmail.com>,
        "Florian Mickler" <florian@mickler.org>,
        "Andi Kleen" <andi@firstfloor.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The following bug entry is on the current list of known regressions
> from 2.6.35.  Please verify if it still should be listed and let the
> tracking team3
> know (either way).

I believe Chris Wilson already fixed it by downgrading the message,
but I don't know if the fix is 2.6.35 track.

-Andi

>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=18332
> Subject		: [regression] *ERROR* timed out waiting for FORCE_DETECT in
> 36rc3 on i915
> Submitter	: Andi Kleen <andi@firstfloor.org>
> Date		: 2010-09-08 13:53 (13 days old)
> Message-ID	: <87mxrswddf.fsf@basil.nowhere.org>
> References	: http://marc.info/?l=linux-kernel&m=128395400624946&w=2
>
>
>

