Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab2LJF6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 00:58:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50976 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2LJF6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 00:58:04 -0500
Date: Sun, 9 Dec 2012 23:57:53 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Rob Landley <rob@landley.net>
Cc: Andy Lutomirski <luto@amacapital.net>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, "Andrew G. Morgan" <morgan@kernel.org>,
        mtk.manpages@gmail.com
Subject: Re: [PATCH] Document how capability bits work
Message-ID: <20121210055753.GA3689@sergelap>
References: <CALCETrXOk74kcfqHBwuAZEY3rpZJFc65e0zZszu-34Qk+ui1dA@mail.gmail.com>
 <1354960297.7646.0@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354960297.7646.0@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Rob Landley (rob@landley.net):
> The fact that you need multiple sets of capabilities per process
> (permitted, inheritable, effective), plus MORE sets (plural) of
> capabilities attached to executable files, plus the "capability
> bounding set" which is presumably so selinux can mess with it, plus

The bounding set was in large part a workaround for the absence of the
user namespace (and, at the time, the devices cgroup).

(Now libcap-ng uses it to try and make capabilities generally easier to
use.)

-serge
