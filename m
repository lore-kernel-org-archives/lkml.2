Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1EYLN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 07:13:29 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35595 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab1EYLN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 07:13:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Tp0jjVFCXClneoWy2El1bDy8HdUPljFhEQkKiY0c0g+NTU31ryKtNF4AYTRm6Eb7yC
         dCxvK+0Bgsy6DTcvLa6Yj/dUQSFilYpMgne6kaQON5VYqoaoXhJhgy1+XpSwAf6aEH7i
         cwj/nj8C4Di4bF9Ny4HstHBriBua9YQoNB9MA=
MIME-Version: 1.0
In-Reply-To: <20110525085816.GA24233@elte.hu>
References: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org>
	<20110525074040.GA9233@elte.hu>
	<20110525085816.GA24233@elte.hu>
Date: Wed, 25 May 2011 14:13:27 +0300
X-Google-Sender-Auth: m_Puh5ol0uXn7jap5YeX1SRi5Ww
Message-ID: <BANLkTikhbf+aUh0d_uO7AUtR9D79jJX8OQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "slub: Remove node check in slab_free"
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>, Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 11:58 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> i too was seeing various instabilities and SLUB corruption in -tip testing.
>> Every 5th randconfig kernel crashes.
>>
>> I started testing the revert.
>
> Stability of -tip has increased dramatically (36 test iterations and
> no crash), so yes this revert resolves the crashes.
>
> I've attached the changelogified revert patch below. James, since i
> was seeing these sporadically you've saved me a couple of hours of
> rather painful bisection work! :-)

Thank you Ingo!
