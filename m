Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab0GULp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 07:45:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53693 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab0GULpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 07:45:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:content-type;
        b=ZFc88NESVsTpnJNY5pTX+2IRn7WOiDZSQQG50TTaEqBRcJKA4xh/GJZnkeHIHUZKKx
         XNiV0r+2RUE/2VFwF5iidO9+ULC+hPufSSiEtmRoxnXK61vumCqBeCzVN75lMWBcecY7
         O/x3cvEWOGE3rHeocxSGxQ6IiLJXHwaRAmM6E=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <AANLkTim9-79EImktArUO2td5nqUAtp-Uag3j4BDzj_-E@mail.gmail.com>
References: <AANLkTim9-79EImktArUO2td5nqUAtp-Uag3j4BDzj_-E@mail.gmail.com>
Date: Wed, 21 Jul 2010 12:45:53 +0100
Message-ID: <AANLkTinnlq27qoTicG-_C26N6Sv8pP8taEkXWF5BUE1b@mail.gmail.com>
Subject: Re: Kernel bisect: a query regarding commit identifiers
From: trapDoor <trapdoor6@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 12:29 PM, trapDoor <trapdoor6@gmail.com> wrote:
> Hello All,
> Just a quick question. I'm going to do kernel bisect and was wondering
> if there are commit identifiers for the rc-GIT versions ? Or maybe I
> won't need it and could just do it like this:
> git-bisect bad 2.6.35-rc2-git3
> git-bisect good 2.6.35-rc2-git4
>
> ?

I meant the other way of course..
git-bisect bad 2.6.35-rc2-git4
git-bisect good 2.6.35-rc2-git3

>
> Identifiers for rc versions appear in changelogs but I can't find
> identifiers for the rc-git's. I think that doing bisect between rc-git
> version within the same rc would save me some time. Assuming I will be
> able to narrow a problem down to a particular rc initially ..


-- 
Regards
trapDoor
