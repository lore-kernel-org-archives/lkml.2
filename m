Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917Ab1J2BT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 21:19:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63462 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932806Ab1J2BTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 21:19:25 -0400
MIME-Version: 1.0
In-Reply-To: <201110290300.57778.vda.linux@googlemail.com>
References: <CAK1hOcN1ocnFh+HJWMONbUmoGtnxGvfrkxjRVs8zNmurz1xdrA@mail.gmail.com>
	<4EAACAF0.4030401@draigBrady.com>
	<4EAACD51.5060703@redhat.com>
	<201110290300.57778.vda.linux@googlemail.com>
Date: Sat, 29 Oct 2011 03:19:24 +0200
Message-ID: <CAFLxGvyDWBNanPutxsZns4_rPcR15AQQ2pJm+6qtTACezXvwbg@mail.gmail.com>
Subject: Re: rename("a", "b") would not always remove "a" on success. ?!!
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Eric Blake <eblake@redhat.com>,
        =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>,
        Coreutils <coreutils@gnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christian Engelmayer <christian.engelmayer@frequentis.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 3:00 AM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
> In my opinion, the key word here is "theoritically".
> Is there even one real-world program which depends on this?
> I bet there is not.
>

The best way to find such a program is breaking it by changing the
kernel's behavior. ;-)

-- 
Thanks,
//richard
