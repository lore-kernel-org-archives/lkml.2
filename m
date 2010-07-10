Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab0GJSgO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 14:36:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64016 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0GJSgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 14:36:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uu97nTEqNB1BJgZl4jjKQtzg35ttwmHxtdlbPfyGxImvCrVkN+rE88kZM3yAjZnWVK
         c8yaLn6mlNaV7H+kliSE8zZJqQM2w5u4AhEMXXvNPc8zWjoLwTI42M8Sf0iw+vUMYsK6
         vGYl9MS17R8Q3ulplt+caOHWGbqwhx1Q8OiNg=
MIME-Version: 1.0
In-Reply-To: <1278751162-10053-1-git-send-email-jslaby@suse.cz>
References: <AANLkTikFmeXz9og4t98jm6QcAdRa6rIeCAv3oeFnTgd8@mail.gmail.com>
	<1278751162-10053-1-git-send-email-jslaby@suse.cz>
Date: Sat, 10 Jul 2010 11:36:10 -0700
Message-ID: <AANLkTik60ShxdSb8mE0BLGKPmSe3saUTPVHbxCBXqPGp@mail.gmail.com>
Subject: Re: [PATCH 1/2] parser: fix and simplify support of asm goto
From: Chris Li <christ.li@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, Larry Finger <Larry.Finger@lwfinger.net>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 1:39 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> +       if (token->ident == &goto_ident) {

You need to test the token type is TOKEN_IDENT before using token->ident.
I will apply your patch with the fix up.

Chris
