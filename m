Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab0KBQKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:10:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35689 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab0KBQKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:10:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Z4reZbWCH5wrs6C/Y7EHtnPKhrU+OKdYsIHliRQJaI4ZFkWk5C1i3Z/Dwc+S3ktgpG
         2l0zNjCq6zNj3XsYzEqevHwSFcgWqLiImLNzh/bp6klVIEiCS0GrMeWlWF2klDTm/dSi
         Q5AAGjq60C+Ts8o0gNn9iv4+zZWzqk13ShWmY=
MIME-Version: 1.0
In-Reply-To: <AANLkTinPDYSV0Xh27AiQNzytsifqXm4Mxa_KwYG8iNb+@mail.gmail.com>
References: <1288711861-3625-1-git-send-email-audun.hoem@gmail.com>
	<1288712259.7326.4.camel@Joe-Laptop>
	<AANLkTinPDYSV0Xh27AiQNzytsifqXm4Mxa_KwYG8iNb+@mail.gmail.com>
Date: Tue, 2 Nov 2010 17:10:24 +0100
Message-ID: <AANLkTi=FX=+rzK0bUJG9D1hDtzsPhA+N2kepWCZkLAQN@mail.gmail.com>
Subject: Re: [PATCH] staging: frontier: alphatrack: fixed coding style issues
From: Audun Hoem <audun.hoem@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Audun Hoem <audun.hoem@gmail.com>, gregkh <gregkh@suse.de>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I was planning to remove the patch in a later patch, which I at the
> time thought was necessary, but in light of this checkpatch fault, I
> guess I could have just pushed it in this one.
Sorry, meant to say "remove the macro," of course.
