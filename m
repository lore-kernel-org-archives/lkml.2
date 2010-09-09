Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab0IIS37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 14:29:59 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36261 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab0IIS35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 14:29:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=fUMYqEzToxRVrXoCIauoLyNoSoaiJyp8DqDtGLZv179APicCXCK89KWOUG+aM9HrTE
         /S7Xt4IPkGYgykQttCPqtZE3Nl2+JQuzQ65icVPBEs5Z0/Fchp2JQg/nAbA5CAtCyp0W
         yIFMRyR2lJludj+Bd9jT/mPTQCsNqHnOEAyQo=
MIME-Version: 1.0
In-Reply-To: <1284056536.24986.182.camel@Joe-Laptop>
References: <1284056536.24986.182.camel@Joe-Laptop>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 9 Sep 2010 14:29:26 -0400
Message-ID: <AANLkTimAuA1oYyoaKsFTPEifdDsz9h=EzTB8gKudyAJk@mail.gmail.com>
Subject: Re: [rfc patch] treewide: Convert "static const char <*> foo[] =" to
 "static const char <*> const foo[] ="
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 9, 2010 at 14:22, Joe Perches wrote:
> To move data to const sections, specify
> that the pointed to strings are also const.

did you find cases where this couldnt be done ?  this is going to keep
creeping back in with new drivers unless we have something like
checkpatch.pl catching it ...

> Any ideas on how best to get this verified and included?

where is the actual patch ?
-mike
