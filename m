Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab0LLBo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 20:44:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54467 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab0LLBo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 20:44:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=E39WbRYi4igkEjz6n/ztWCLqQ3JL2KnUKYkt1t1DuCI/EWzb3aXa2216H2fp17F5Rt
         NHukWbQlhVXmVKfqQ+86MEJIc5K+2NiW9SY1aZIyCoQet2+54seL6/4uNOYhUqVTy4SJ
         dXBc22V6S3ys91R3281mLoj95uFoluMDA4LEI=
MIME-Version: 1.0
In-Reply-To: <1292086079-4137-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1292086079-4137-1-git-send-email-broonie@opensource.wolfsonmicro.com>
From: Cory Maccarrone <darkstar6262@gmail.com>
Date: Sat, 11 Dec 2010 17:44:04 -0800
Message-ID: <AANLkTikefALSwnVdicnuDitZ4_nqthgsB5tZaQ1DubSw@mail.gmail.com>
Subject: Re: [PATCH] mfd: Staticise internal functions in HTC I2CCPLD driver
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 8:47 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> Most of these are GPIO operations, though a couple are just internal only
> functions.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/htc-i2cpld.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
>

Looks good to me, and works fine.  Thanks for this!

Signed-off-by: Cory Maccarrone <darkstar6262@gmail.com>

- Cory
