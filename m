Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab1CCUpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:45:38 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59485 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758733Ab1CCUph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:45:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qDOl+Bz4K0I1731/06Uwm3Opk/kml5StUw5JElAMW0K4NWoggy7pWYKFJEgcKd44j6
         T0TX9z4JRF+taSMrJdQTHUBYG8pA07tA2Yu5f4D5P1Q2mQU/bP7Cy/3Lg09TWkwoeQHR
         0mgOL9WGOzx0Fi2sM8CLgsCIzU8Baw1aHSgUU=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1103032100360.2430@swampdragon.chaosbits.net>
References: <20110303193006.GA29129@svh.nico22.de>
	<alpine.LNX.2.00.1103032100360.2430@swampdragon.chaosbits.net>
Date: Thu, 3 Mar 2011 21:45:35 +0100
Message-ID: <AANLkTi=B3Bpq=5Oyh2FjSX0o_R=Tmwx-ksfMq1bqA_ix@mail.gmail.com>
Subject: Re: Network link detection
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: =?ISO-8859-1?Q?Nico_Sch=FCmann?= <dev@nico22.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 9:03 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Thu, 3 Mar 2011, Nico Schümann wrote:
>
>> Dear kernel developers,
>>
>> currently I'm looking for a way to find out whether a network link went
>> down or up. Of course there is mii-tool, which can watch devices, too.
>>
>> So for now, I created a small program that polls the MII_LINK_OK
>> flag with the SIOCGMIIREG ioctl - the same thing that mii-tools does.
>> But polling that often for a link change that occurs maybe once in a
>> month sounds like waste of energy.
>>
>> Unfortunately, I was not able to find out a way to be notified about
>> link status changes asynchronously. Is there a way? I'm looking for
>> something like "inotify for link states".
>>
> I guess you could use inotify to keep an eye on the 'carrier' file in
> sysfs (for example, from my system;
> /sys/devices/pci0000:00/0000:00:19.0/net/eth0/carrier )
> That file will contain "0" if there is no link and "1" if there is a link.

Does sysfs support inotify?
I don't think so.

> --
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Plain text mails only, please.
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
>

-- 
Thanks,
//richard
