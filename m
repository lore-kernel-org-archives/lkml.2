Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab2IADDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 23:03:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44936 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab2IADDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 23:03:49 -0400
MIME-Version: 1.0
In-Reply-To: <87ipbyfw9j.fsf@xmission.com>
References: <20120831213126.GA19688@www.outflux.net>
	<20120831223908.4aa5574d@pyramind.ukuu.org.uk>
	<CACLa4pv75-HaPEas=aOMySbMm-YdSJZdc6qtNUnTM+Ev2Rp7rg@mail.gmail.com>
	<87ipbyfw9j.fsf@xmission.com>
Date: Fri, 31 Aug 2012 20:03:46 -0700
Message-ID: <CACLa4ptpGJ7YDTqmOvtHq_Ts9f72SBV6Q_HDDw1OebhxVOzU9w@mail.gmail.com>
Subject: Re: [PATCH] security: unconditionally call Yama
From: Eric Paris <eparis@parisplace.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        John Johansen <john.johansen@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 4:59 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:

> From a overal kernel maintenance and use perspective the unconditional
> enablement is a pain.
>
> We long ago established the principle that compiling additional code
> into the kernel should not change the semenatics of the kernel.
>
> So this code needs to come with a command line or sysctl on/off switch
> not an unconditional enable.

Your argument makes zero sense.  If I decide to build new code, that
new code can do something.  It happens all the time.  If you don't
like Yama, don't build Yama.  If you don't like the only thing that
Yama does (it only implements one protection), disable that protection
from sysctl.  I don't get it.

-Eric
