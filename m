Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1BNTxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:53:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab1BNTxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:53:52 -0500
Subject: Re: [PATCH 2/2] security: remove unused security_sysctl hook
From: Eric Paris <eparis@redhat.com>
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
In-Reply-To: <AANLkTimGVCCTVjdw3ODPDGHF9bdJMPUz4JR=1oG86EtF@mail.gmail.com>
References: <1296578542-5902-1-git-send-email-lucian.grijincu@gmail.com>
	 <1296578696-5989-1-git-send-email-lucian.grijincu@gmail.com>
	 <1296587121.12605.30.camel@moss-pluto>
	 <658335B0-9138-4293-9E25-B557AE0DEF7A@redhat.com>
	 <AANLkTimGVCCTVjdw3ODPDGHF9bdJMPUz4JR=1oG86EtF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 14:53:47 -0500
Message-ID: <1297713227.2783.30.camel@unknown001a4b0c2895>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 21:33 +0200, Lucian Adrian Grijincu wrote:
> On Tue, Feb 1, 2011 at 10:06 PM, Eric Paris <eparis@redhat.com> wrote:
> >
> >
> >
> >
> > On Feb 1, 2011, at 2:05 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> >
> >> On Tue, 2011-02-01 at 18:44 +0200, Lucian Adrian Grijincu wrote:
> >>> The only user for this hook was selinux. sysctl routes every call
> >>> through /proc/sys/. Selinux and other security modules use the file
> >>> system checks for sysctl too, so no need for this hook any more.
> >>>
> >>> Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
> >>
> >> Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
> >
> > I've applied both to the selinux tree. Thanks
> 
> 
> I've checked both these trees (on all published branches):
>   git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
>   git://git.infradead.org/users/eparis/selinux.git
> 
> and there's no trace of these patches.
> 
> 
> Am I not looking in the right places for these patches?

The second one is the right tree, I just forgot to push!  Pushed now!
Sorry.

-Eric


