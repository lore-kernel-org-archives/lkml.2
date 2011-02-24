Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab1BXTqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:46:16 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60607 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab1BXTqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:46:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Gf7NyElzIu76GxjG71ghAdwKsrb4hMLbLZu264OaPn5GHdUFtEya3w3GlDl9oa77gm
         wkeMYDLTSBtsBrG6qwpJJs0KNw2D/venb4ygUKZGj9UCxZBnTL1DXNS+6VKaI4uYeX+C
         cSYOTHGmnnPrYGjNf8mBO11oLQPIIEG1Y5vi0=
MIME-Version: 1.0
In-Reply-To: <20110224193211.GC15498@elte.hu>
References: <20110224145128.GM7840@htj.dyndns.org>
	<4D66AC9C.6080500@kernel.org>
	<20110224192305.GB15498@elte.hu>
	<4D66B176.9030300@kernel.org>
	<20110224193211.GC15498@elte.hu>
Date: Thu, 24 Feb 2011 20:46:11 +0100
X-Google-Sender-Auth: SBT9y0uZMoaLbg43auABlh6xVjA
Message-ID: <AANLkTimvJ=BLDjoRDXg_TRSepd9GoDx-w_FonSCZtybi@mail.gmail.com>
Subject: Re: [GIT PULL tip:x86/mm]
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 24, 2011 at 8:32 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> DavidR reported that x86/mm broke his numa emulation with 128M etc.
>
> That regression needs to be fixed. Tejun, do you know about that bug?

Nope, David said he was gonna look into what happened but never got
back.  David?

Thanks.

-- 
tejun
