Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab1ADThY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 14:37:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41714 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1ADThX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 14:37:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FcPGltH93VMCMNKi2LIvuhVPsexqMmIszJ6RzvBYRJ7zyFG4sm9y3hdQn4mfbQ5E5D
         T2I0ViGMTKm6koNgCAGrx/e1YZ4PnNEclXtVz6SwKD6MB+qaCy1pZLExQy6lXlebtbGB
         M0OXC2T6pVXRcQd5wW79ByobJq190435Mrwz4=
MIME-Version: 1.0
In-Reply-To: <20110104061821.GA25886@gherkin.frus.com>
References: <20110104061821.GA25886@gherkin.frus.com>
From: Matt Turner <mattst88@gmail.com>
Date: Tue, 4 Jan 2011 14:37:00 -0500
Message-ID: <AANLkTikOsULOVq01CEiPuoK4-sFTk+KWJiLY0wnzUZ17@mail.gmail.com>
Subject: Re: [BUG] implicit declaration of kfree/kzalloc in i2c-i801.c on Alpha
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        mcree@orcon.net.nz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 1:18 AM, Bob Tracy <rct@gherkin.frus.com> wrote:
> Another 2.6.37-rc8 build failure on alpha:
>
> (...)
>  CC [M]  drivers/i2c/busses/i2c-i801.o
> drivers/i2c/busses/i2c-i801.c: In function 'i801_probe':
> drivers/i2c/busses/i2c-i801.c:737: error: implicit declaration of function 'kzalloc'
> drivers/i2c/busses/i2c-i801.c:737: warning: assignment makes pointer from integer without a cast
> drivers/i2c/busses/i2c-i801.c:855: error: implicit declaration of function 'kfree'
> make[3]: *** [drivers/i2c/busses/i2c-i801.o] Error 1
> make[2]: *** [drivers/i2c/busses] Error 2
> make[1]: *** [drivers/i2c] Error 2
> make: *** [drivers] Error 2
>
> --Bob

Is this specific to alpha? I wonder why we don't see this on other platforms?

Thanks Bob,
Matt
