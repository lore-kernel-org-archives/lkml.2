Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0KFUvI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 16:51:08 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64568 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab0KFUvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 16:51:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=M1DL95jPa7qL2S/Oq4AcMdTMxVVapZC4V63U2EXAiqSpov5nd5TvY/2pRC0OIXntq3
         IxgAGQv9/5wttITfW0yoBmhtYey7tEZ4Vk/jE7BiYApL7UNU5ZhJ85OAiOF4CL57IvHe
         ZBMCqCntqqnktJVRPSsMaw9lPsdj1N2qHVLcE=
MIME-Version: 1.0
In-Reply-To: <20101106195705.GA26765@core.coreip.homeip.net>
References: <1289070464-3392-1-git-send-email-tdent48227@gmail.com>
	<20101106195705.GA26765@core.coreip.homeip.net>
Date: Sat, 6 Nov 2010 16:51:05 -0400
Message-ID: <AANLkTikYLn3TQdKFd-Du33y5tuXhX08P1TYcJG0eCbtJ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Drivers: hid: Makefile: Cleaned up Makefile
From: Tracey Dent <tdent48227@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: jkosina@suse.cz, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        spbnick@gmail.com, chatty@enac.fr
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/10, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> Hi Tracey,
>
> On Sat, Nov 06, 2010 at 03:07:43PM -0400, Tracey Dent wrote:
>> Changed Makefile to use <modules>-y instead of <modules>-objs.
>>
>
> Changelog normally should say why something has been done as what has
> been done is pretty clear from the patch itself.
>

Do you want me to resend patch with more descriptive changelog?

> Thanks.
>
> --
> Dmitry
>

regards

td
