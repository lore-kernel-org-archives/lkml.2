Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0HRTQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:16:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53416 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab0HRTQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:16:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=Ip6OO4IrP3BRO4U/8PymS4sGVe/aQErkS8/0VHVvmMQbrOrUVzSnPUb4UaqxBRFWLO
         thMl624yLmKXA5XdzHDdcoYOdxXtIb0dKnHlyGdZvvFBXESE19ehj4o35ezIOi04Sa8+
         lIyvjoOJn5q5oXRRxS58FF6j8DGEk+Qq5SRBE=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <201008182102.03201.maciej.rutecki@gmail.com>
References: <201008182102.03201.maciej.rutecki@gmail.com>
Date: Wed, 18 Aug 2010 20:16:22 +0100
Message-ID: <AANLkTik3S91w+92rz-KdHd_U=yfuSPbDWWhD_Vu_rDR9@mail.gmail.com>
Subject: Re: [REGRESSION] [SUSPEND] Opps during suspend to disk (probably also
 during to ram)
From: trapDoor <trapdoor6@gmail.com>
To: maciej.rutecki@gmail.com
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 8:02 PM, Maciej Rutecki
<maciej.rutecki@gmail.com> wrote:
> Last known good kernel: 2.6.35
> Failing kernel: 2.6.36-rc1
>
> When I try suspend to disk under 2.6.36-rc1 ("no_console_suspend" option
> enabled) system hangs on this message:
> http://unixy.pl/maciek/download/kernel/2.6.36-
> rc1/zlom/suspend_issue/dsc_0001.jpg
>
Hello,

I see on the screenshot some messages related to HID so perhaps you
have the same issue I came across recently. If it happens so this
commit should fix it:
http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commitdiff;h=9c9e54a8df0be48aa359744f412377cc55c3b7d2

For more details please refer to:
https://bugzilla.kernel.org/show_bug.cgi?id=16615
or:
http://lkml.org/lkml/2010/8/18/92   #currently dead



-- 
Regards
Tomasz B.
