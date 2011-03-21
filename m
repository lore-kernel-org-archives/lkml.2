Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab1CUQ0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:26:44 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:53022 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab1CUQ0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:26:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xqwO0WfgSD7sE/k4soChfBr0ruGNZoWH46REIkIsBqfXjNsXEjZfaSm3VeWdi6Nr+p
         VrqnXkcI8prKTH3fUPqEnY1RAa7yb/cX6Vl50Lhz1P+fB15ZavIMFbqw/aOvx7Yic9J4
         LvjNOGKM0k/OtGad29EyqPl0D92V0aiISPiRY=
MIME-Version: 1.0
In-Reply-To: <1300713844-8167-1-git-send-email-j.neuschaefer@gmx.net>
References: <1300713844-8167-1-git-send-email-j.neuschaefer@gmx.net>
Date: Mon, 21 Mar 2011 18:26:41 +0200
X-Google-Sender-Auth: Ff2GQ4TBxNhGdmKkX5AN_PCPwkM
Message-ID: <AANLkTin7B+=-n_Tm4id15rG2B0hEqCBKAxMLerENgMqa@mail.gmail.com>
Subject: Re: [PATCH] staging: winbond/mto.c: remove unused variables
From: Pekka Enberg <penberg@kernel.org>
To: =?ISO-8859-1?Q?Jonathan_Neusch=E4fer?= <j.neuschaefer@gmx.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Pavel Machek <pavel@ucw.cz>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 3:24 PM, Jonathan Neuschäfer
<j.neuschaefer@gmx.net> wrote:
> They are unused since commit a22517fec0b13b5813932a3583a2b11a2ee17f5d:
>
>    Staging: w35und: remove dead code from mto.c
>
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

Acked-by: Pekka Enberg <penberg@kernel.org>
