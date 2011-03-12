Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab1CLFBz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 00:01:55 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51119 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1CLFBy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 00:01:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=A3d0mIiPrxpkNLTx/I+/Hwveb19zNUBX/vguGvzgcofsrqgcjJmdr5bksL5ovWapHM
         v9LjDtYpdovVLcAMZ06clQDuM6ZB1+4Ydo1lxPdZEh6rPBKeLHUXZRsWhiRK9Fu9upM1
         LYxC2tQVtspaMAA7uoXl4lOe85sgiSZ0Xjnpk=
MIME-Version: 1.0
In-Reply-To: <20110311161924.b902942a.akpm@linux-foundation.org>
References: <1299822937-6522-1-git-send-email-roland@kernel.org>
 <x49fwqthh51.fsf@segfault.boston.devel.redhat.com> <20110311161924.b902942a.akpm@linux-foundation.org>
From: Roland Dreier <roland@kernel.org>
Date: Fri, 11 Mar 2011 21:01:33 -0800
X-Google-Sender-Auth: 4DhxhcwARuRJqg3k7pHDsOxlOuk
Message-ID: <AANLkTin39BqoZt-zhs-YFyvf5Y6kwcd89mQvem9VBzJc@mail.gmail.com>
Subject: Re: [PATCH] aio: Wake all waiters when destroying ctx
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 4:19 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> It's a fairly old bug (yes?) and we're presumably close to 2.6.38.  So
> I scheduled the fix for 2.6.39 marked for backporting into 2.6.38.x and
> earlier.

Yes, AFAICT it's been there approximately forever.

I agree that this is 2.6.39 stuff, and I included the stable@ cc so it gets
into 2.6.38.1.  Seems like the best course.

 - R.
