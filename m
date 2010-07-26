Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab0GZWII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:08:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35941 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab0GZWIG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:08:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G4bFWRwuNIyOh2XhfuIvVrwwjaYOpltBYJOqpWSmFaTPTYwEdGWyzX8dFfjLvO4INV
         7SE8Kbos72oaKGj0o4dhXyMzZTkgL7iuc7t6xuNrEf3xDL9dlq/CKWSi3wg/4Htq0v57
         gu88/WWlN1KO+Ho7C1XUPYY3dI6tY8yYI41t4=
MIME-Version: 1.0
In-Reply-To: <20100726220546.GB9671@suse.de>
References: <20100722182638.GA12712@kroah.com>
	<AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
	<20100722183614.GA5443@suse.de>
	<AANLkTinsd2gWOHb3w9gzvKO5vdwLBT7DZOY+2xCUz_5_@mail.gmail.com>
	<AANLkTimm9XGvK2H55V7N76JPU05iHk_dY5JjOLifQTsr@mail.gmail.com>
	<AANLkTi=OMaKuk+ReeqCfBGes76BjKYyUdqxPOQfH8EcZ@mail.gmail.com>
	<20100726212858.GA15904@suse.de>
	<AANLkTimmAfhw7WhPHHU6d4izkzvp2oxOSzNN8JjNu_nU@mail.gmail.com>
	<20100726220546.GB9671@suse.de>
Date: Tue, 27 Jul 2010 00:08:03 +0200
Message-ID: <AANLkTi=d1-Uf4TeyvMH3evo91zPWjbincij=HC0ny0Ym@mail.gmail.com>
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Paul Menage <menage@google.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 12:05 AM, Greg KH <gregkh@suse.de> wrote:
> On Mon, Jul 26, 2010 at 02:55:18PM -0700, Paul Menage wrote:
>> On Mon, Jul 26, 2010 at 2:28 PM, Greg KH <gregkh@suse.de> wrote:
>> >
>> > Ok, again, after all of this, who is going to be applying this patch to
>> > their tree for the .36 merge window?
>>
>> There's no specific cgroups tree - cgroups patches generally go via akpm.
>>
>> >
>> > Or should I apply it to my driver-core one?
>> >
>>
>> That sounds like an OK option too.
>
> Wonderful, can I get some acks from the cgroups maintainers?  I'll
> gladly take it through my tree.
>

while I am not a maintainer, from the libcgroup side at least,

Acked-by: Dhaval Giani <dhaval.giani@gmail.com>

> thanks,
>
> greg k-h
>
