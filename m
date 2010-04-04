Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab0DDBqB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 21:46:01 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:42739 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab0DDBpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 21:45:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JrydMj1AM8mn43UrnWTPTyU5lGyhVf9VBiLp4A5s6z9YoaRdt4M0MOHA1sb+7wGIFb
         QU8SLcLWkHFTMKDE8vBFbfPAx+8IVRg6gKVEo2dmezR1hb8ta0V5nxtdnnuGikfFgpm7
         9e68+5wtZ4LINcCqIaqkiv2C4Kvmd7F+/q03s=
MIME-Version: 1.0
In-Reply-To: <201004040312.28481.sven.eckelmann@gmx.de>
References: <1270341625-28764-1-git-send-email-luisbg@ubuntu.com>
	 <201004040312.28481.sven.eckelmann@gmx.de>
Date: Sun, 4 Apr 2010 02:45:52 +0100
X-Google-Sender-Auth: a97f9102cfadccf9
Message-ID: <p2x506b70dc1004031845p81705070o325d93f839c80e9a@mail.gmail.com>
Subject: Re: [PATCH 4/4] Staging: batman-adv: fix whitespace style issues
From: Luis de Bethencourt <luisbg@ubuntu.com>
To: Sven Eckelmann <sven.eckelmann@gmx.de>
Cc: devel@driverdev.osuosl.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       b.a.t.m.a.n@lists.open-mesh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 4, 2010 at 2:12 AM, Sven Eckelmann <sven.eckelmann@gmx.de> wrote:
> Luis de Bethencourt wrote:
>> This patch fixes the 32 unnecessary whitespaces before a quoted
>> newline that the batman-adv files had.
>
> Thanks.
>
> Your patch conflicts with patches waiting to be applied by Greg KH. I will
> redo your changes for the current and development version and submit them to
> the b.a.t.m.a.n. mailing list for further discussion. Is that ok for you?
>
> Best regards,
>        Sven Eckelmann
>

Sven,

Sorry about the conflict, thanks for redoing the changes. Where can I
find the current and development branches? I want to avoid doing this
mistake again in the future. Specially since I'm planning on doing
some janitorial work on Staging for a while if it's OK with you guys.
I see it as nice experience and practice while learning and getting
ready for more valuable contributions :)

Cheers,
Luis de Bethencourt
