Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab1EKQWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:22:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49571 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab1EKQWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:22:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=M4DT+hSdUfnK1Xp/0Nf7GBrRejD8iBhg5nPd/R5+76Ex88OySyO+XOEw8XgSz/v72C
         1Irfrb/uL0GxINVeSPNdF0P/4lAsCZvXXsCxrpIJgc4CbPHYERiV2ECDYNIA4ztH6kPR
         /Isqi+7ILyGAONBLOEQAPsl06aqht9/6aiozE=
MIME-Version: 1.0
In-Reply-To: <1304687090-23401-1-git-send-email-linus.walleij@stericsson.com>
References: <1304687090-23401-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 11 May 2011 14:39:03 +0200
X-Google-Sender-Auth: V8MNVe3L50zUm-n3hvChKGTgqmo
Message-ID: <BANLkTikHwd-Nsoq9eVwf1jTfSAUiA59R5g@mail.gmail.com>
Subject: Re: [PATCH 00/10] Ux500 PRCMU into MFD and update deps
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/6 Linus Walleij <linus.walleij@stericsson.com>:

> I will attempt to slim this down a bit, mainly the set is a
> review point for the MFD maintainer to check out if the PRCMU
> driver fits within MFD.

Sam will you be able to provide some feedback on this so I know
whether I shall plan to polish it up for the 2.6.40 merge window or
not? (Just so I know, I can do other things too, this happens to be
pretty central and subject to a horde of Gantt-type dependencies.)

Linus Walleij
