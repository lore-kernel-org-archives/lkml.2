Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab1FQOq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:46:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39841 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759152Ab1FQOqY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:46:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=o2jlY6mtsprvYJKvm7BgdU7+AsRgUwmJnlV2jkIuaN3bjar0tp9X2AShCgbQRKHL3p
         r0JgcUAL6SMhjMLiZb+Y+qfL5l9i+Yz5nRdtz///URsADwQPz7Pgne8hn+BhWrNVtZ68
         407FVN4nXa2ItixYDhgpJglLInzkDlshkqlIE=
MIME-Version: 1.0
In-Reply-To: <BANLkTin8b2suL1675DKvHbeXuCzeCFJeOg@mail.gmail.com>
References: <BANLkTin8b2suL1675DKvHbeXuCzeCFJeOg@mail.gmail.com>
From: Paul Hartman <paul.hartman@gmail.com>
Date: Fri, 17 Jun 2011 09:46:04 -0500
Message-ID: <BANLkTin-iYMvbuq=DGo8JZa_vYUMsd24jQ@mail.gmail.com>
Subject: Re: New Gentoo install on Intel Z68/i7-2600K system hangs after
 VFS:Mounted root...
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 10:11 PM, Mark Knecht <markknecht@gmail.com> wrote:
>   I've got a Windows friend who's trying to make the jump to Gentoo
> Linux. He's purchased a new motherboard & processor which I believe
> are part of the new 'Sandy Bridge' family:
>
> http://www.newegg.com/Product/Product.aspx?Item=N82E16813131730
> http://www.newegg.com/Product/Product.aspx?Item=N82E16819115070
>
> I've installed Gentoo. The kernel is 2.6.38-gentoo-r6. The install
> seemed to go fine. This is my first install from scratch after the
> switch to OpenRC.
>
>   When the machine boots it makes it through mounting sda3 on root,
> which looks OK to me, but then just hangs with no other messages. I've
> posted a photo of what the screen looks like when it stops:
>
> http://www.flickr.com/photos/29328985@N03/5841311388/

Hi Mark,

Have you tried booting with acpi=off ?

Also, since it's a new build, have you done a memory test to be sure
it is stable? Getting the RAM timings/voltages right is usually one of
the biggest hurdles in building a new machine in my experiences.
