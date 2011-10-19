Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab1JSV2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:28:45 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58191 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab1JSV2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:28:44 -0400
MIME-Version: 1.0
In-Reply-To: <20111019204128.GA6152@kroah.com>
References: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
 <1318954079-16666-2-git-send-email-mark.einon@gmail.com> <20111019204128.GA6152@kroah.com>
From: Mark Einon <mark.einon@gmail.com>
Date: Wed, 19 Oct 2011 22:28:24 +0100
Message-ID: <CANK3SE2AEKhw8zSXn3jtGggYh8+SS1mX7Kaue6+vU+B5VjAxWg@mail.gmail.com>
Subject: Re: [PATCH 01/26] staging: et131x: Put all .c files into one big file
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 October 2011 21:41, Greg KH <greg@kroah.com> wrote:
> On Tue, Oct 18, 2011 at 05:07:34PM +0100, Mark Einon wrote:
>> Created one big .c file for the driver, moving the contents of all
>> driver .c files into it.
>>
>> Signed-off-by: Mark Einon <mark.einon@gmail.com>
>
> Something is wrong here, when I try to apply this patch with git, I get
> the following errors:
[...]
>
> Care to resend it with the file actually deleted?  How are you
> generating this patch?
>
> And, when you resend the series, don't put the [RESEND] in the subject,
> I had to edit that out in order to apply them properly (which turned out
> to be a waste of time due to this patch not applying...)

Apologies Greg, I didn't mean to waste your time.

I've used this command to generate the patch, in order not to include
the entire file contents that have been deleted:

git format-patch -D <to-list> <patches>

I also assumed RESEND was commonly used for the purpose of resending
patches. Is this not the case?

Cheers,

Mark
