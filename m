Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab2LPE3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 23:29:25 -0500
Received: from ares07.inai.de ([5.9.24.206]:35917 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab2LPE3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 23:29:24 -0500
Date: Sun, 16 Dec 2012 05:29:21 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
In-Reply-To: <20121003161702.GA22008@kroah.com>
Message-ID: <alpine.LNX.2.01.1212160527210.17128@nerf07.vanv.qr>
References: <20121002195042.GA16087@www.outflux.net> <20121003132538.GE13192@linux.vnet.ibm.com> <20121003161702.GA22008@kroah.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2012-10-03 18:17, Greg Kroah-Hartman wrote:
>> 
>> OK, I will bite...  How should I flag an option that is initially only
>> intended for those willing to take some level of risk?
>
>In the text say "You really don't want to enable this option, use at
>your own risk!"  Or something like that :)

You know that won't not work, just like "everybody is encouraged
to upgrade" for -stable. It needs to say "All users must disable this!"
