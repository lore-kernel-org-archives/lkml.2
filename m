Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab0KBOee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 10:34:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36741 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab0KBOe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:34:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iJ39wXKLwAoG4pkeS2r34nEozEcvifcP1jmvKorv75dMSomvD/ymNPqWbNr8Hrljn9
         xg/6Mubn9io2i/vxzqu8QSO2bpeje1o9pt9eEM6v7rLamPsn47oXAbwfJCwIJnYqhO7t
         XeYa5wrC47NC9F66gR/dCg5X1OzW5e80dICYY=
MIME-Version: 1.0
In-Reply-To: <87oca7evbo.fsf@gmail.com>
References: <1288668052-32036-1-git-send-email-bgamari.foss@gmail.com>
	<alpine.DEB.2.00.1011012030100.12298@chino.kir.corp.google.com>
	<87oca7evbo.fsf@gmail.com>
Date: Tue, 2 Nov 2010 23:34:27 +0900
Message-ID: <AANLkTimDPdDHAg0Odp0WchOLKh3OUSOWX7_0ps8eizFk@mail.gmail.com>
Subject: Re: [PATCH] Add Kconfig option for default swappiness
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/2 Ben Gamari <bgamari.foss@gmail.com>:
> On Mon, 1 Nov 2010 20:33:10 -0700 (PDT), David Rientjes <rientjes@google.com> wrote:
>> And they can't use an init script to tune /proc/sys/vm/swappiness
>> because...?
>
> Packaging concerns, as I mentioned before,
>
> On Mon, Nov 01, 2010 at 08:52:30AM -0400, Ben Gamari wrote:
>> Ubuntu ships different kernels for desktop and server usage. From a
>> packaging standpoint it would be much nicer to have this set in the
>> kernel configuration. If we were to throw the setting /etc/sysctl.conf
>> the kernel would depend upon the package containing sysctl(8)
>> (procps). We'd rather avoid this and keep the default kernel
>> configuration in one place.
>
> In short, being able to specify this default in .config is just far
> simpler from a packaging standpoint than the alternatives.
>
Hmm, then, can't we add a sysctl template config/script for generic
sysctl values ?
Adding this kind of CONFIG one by one seems not very helpful...

Thanks,
-Kame
