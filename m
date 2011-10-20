Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab1JTATQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 20:19:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34834 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab1JTATP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 20:19:15 -0400
MIME-Version: 1.0
In-Reply-To: <20111019231716.GA10113@kroah.com>
References: <1319065048-2767-1-git-send-email-mark.einon@gmail.com> <20111019231716.GA10113@kroah.com>
From: Mark Einon <mark.einon@gmail.com>
Date: Thu, 20 Oct 2011 01:18:55 +0100
Message-ID: <CANK3SE0FALr1-HMoGNsKPKhv+rv=2hEmVTzq33DBg61-o1+JZw@mail.gmail.com>
Subject: Re: [PATCH 00/19] Resend previous incorrecly formatted patches
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 October 2011 00:17, Greg KH <greg@kroah.com> wrote:
> On Wed, Oct 19, 2011 at 11:57:09PM +0100, Mark Einon wrote:
>> Resending patches, these have now been formatted with:
>>
>> git format-patch -k -M
>>
>> Tested with git am sucessfully on a local tree
>
> But when you sent them, they did not have any [xx/yy] markings on them
> so I have no idea what order to apply them in.
>
> Did you use git send-email to send these?  If not, why not?

Gahhh, sorry. I just blindly used the git format-patch line you
provided, and the -k option removes the [xx/yy] markings. git
send-email was used to send them.

I will send the patches once more to you with the markings. I'll avoid
spamming the mailing lists with them once more.

Thanks for your patience,

Mark

>
> We'll get this right one of these tries :)
>
> greg k-h
>
