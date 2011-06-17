Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab1FQO5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:57:20 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40952 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757946Ab1FQO5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:57:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IOYh/4tgyhIr9uW7UVP64lMyZ1ZdV7l2lxNHpnVekiDXrhaYk9Aomdx3rHLs1NYyTX
         d0o7ujybmYQhOWRGB2zteDjMVDwGwf8+sQ075aIVgm4mWnw/29201UkQJLMWf0ZNhcBb
         6eRzfTQYQxtqE1GcaKRGfpVq49tlNbP4EPzbU=
MIME-Version: 1.0
In-Reply-To: <BANLkTin-iYMvbuq=DGo8JZa_vYUMsd24jQ@mail.gmail.com>
References: <BANLkTin8b2suL1675DKvHbeXuCzeCFJeOg@mail.gmail.com>
	<BANLkTin-iYMvbuq=DGo8JZa_vYUMsd24jQ@mail.gmail.com>
Date: Fri, 17 Jun 2011 07:57:17 -0700
Message-ID: <BANLkTi=_0xLbk_f6_2koh2pN=u-A=Jb7Og@mail.gmail.com>
Subject: Re: New Gentoo install on Intel Z68/i7-2600K system hangs after
 VFS:Mounted root...
From: Mark Knecht <markknecht@gmail.com>
To: Paul Hartman <paul.hartman@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 7:46 AM, Paul Hartman <paul.hartman@gmail.com> wrote:
> On Thu, Jun 16, 2011 at 10:11 PM, Mark Knecht <markknecht@gmail.com> wrote:
>>   I've got a Windows friend who's trying to make the jump to Gentoo
>> Linux. He's purchased a new motherboard & processor which I believe
>> are part of the new 'Sandy Bridge' family:
>>
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16813131730
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16819115070
>>
>> I've installed Gentoo. The kernel is 2.6.38-gentoo-r6. The install
>> seemed to go fine. This is my first install from scratch after the
>> switch to OpenRC.
>>
>>   When the machine boots it makes it through mounting sda3 on root,
>> which looks OK to me, but then just hangs with no other messages. I've
>> posted a photo of what the screen looks like when it stops:
>>
>> http://www.flickr.com/photos/29328985@N03/5841311388/
>
> Hi Mark,
>
> Have you tried booting with acpi=off ?
>
> Also, since it's a new build, have you done a memory test to be sure
> it is stable? Getting the RAM timings/voltages right is usually one of
> the biggest hurdles in building a new machine in my experiences.
>
Paul,
   Great inputs. We'll try them both tonight.

Cheers,
Mark
