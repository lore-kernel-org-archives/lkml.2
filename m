Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab1CUIVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 04:21:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35106 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1CUIVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 04:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=GGdT1U+zDv4GS7VYUDT6UtT7175z4m1bu/ZrRG0Yu6YDY03S4lgIAjNlb2I2ltrFPI
         v3qhQhJCBKTLdgsddvDu6ktPS+DfVAJYhtAzOD6huUbVOp7J+texbj1i7Bc7ZgU5/I8i
         yFhJO28nkveCacUQOxjpFVMWK5w97gmTJ4uX4=
MIME-Version: 1.0
In-Reply-To: <20110321122615.8a639909.sfr@canb.auug.org.au>
References: <20110321122615.8a639909.sfr@canb.auug.org.au>
Date: Mon, 21 Mar 2011 09:21:34 +0100
X-Google-Sender-Auth: EdgmRxMGaDexlQYmvPAuHFm86SA
Message-ID: <AANLkTikoF9fkZshaoop7gfuCKjjtUjbwwOG6hWyeGCHJ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the mfd tree with Linus' tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philippe Langlais <philippe.langlais@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/21 Stephen Rothwell <sfr@canb.auug.org.au>:

> I fixed them up (see below) and can carry the fix as necessary.

Fix looks correct, Sam if you push this to the MFD tree before
the pull request I'll be happy.

Yours,
Linus Walleij
