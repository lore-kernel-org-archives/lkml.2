Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1FTLbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 07:31:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39871 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab1FTLbG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 07:31:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Lq5bWXjUCk+n9mWTOWp6511D1Vfjyrfem+jfkcV/J3WsANEtUAKxQnu7ilohJ5HTBD
         UotbK6SzkBdtYaBXOuxxnDrFtkoo4SRhm1Yc6vivEaH5b4LVm6xPXL96EBrSgG6U4i1+
         tkRMbYxZOUUOG+06iXF0XBH/2DMBQPWPthm10=
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1106202040400.10448@tundra.namei.org>
References: <alpine.LRH.2.00.1106192154220.7503@taiga.selinuxproject.org>
 <alpine.LRH.2.00.1106201455560.6055@tundra.namei.org> <20110620103917.GA5230@albatros>
 <alpine.LRH.2.00.1106202040400.10448@tundra.namei.org>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 20 Jun 2011 20:23:28 +0900
Message-ID: <BANLkTi=vdCDnD-_Ut0si=dZ=zcDc_yiU0A@mail.gmail.com>
Subject: Re: [RFC 2/5 v4] procfs: add hidepid= and gid= mount options
To: James Morris <jmorris@namei.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/20 James Morris <jmorris@namei.org>:
> On Mon, 20 Jun 2011, Vasiliy Kulikov wrote:
>
>> > Can you provide evidence that this is a useful feature?  e.g. examples of
>> > exploits / techniques which would be _usefully_ hampered or blocked.
>>
>> First, most of these files are usefull in sense of statistics gathering
>> and debugging.  There is no reason to provide this information to the
>> world.
>>
>> Second, yes, it blocks one source of information used in timing attacks,
>> just use reading the counters as more or less precise time measurement
>> when actual timing measurements are not precise enough.
>
> Can you provide concrete examples?

Vasiliy,

I'm now stand aside James. I mean, if we don't understand your usecase
clearly. we can't gurantee to don't break the feature in the future. So,
we strongly hope to understand it.

Moreover, _now_ I haven't understand your concrete usecase, and then
_I_ can't review and be convinced your code. Please please avoid one line
answer as far as possible, please provide us more information.
