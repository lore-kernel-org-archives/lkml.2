Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab1FNDJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 23:09:44 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62346 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1FNDJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 23:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FyoKI3w3WQ2VdDmmnzxFbRUKVfWauFYWkVZrqrvUQxNZg2+wY2VfzX62YzOHbHZgf0
         48UBf53mv4tMjKhS31mzNTamRQJoZfH0PUUWmkMMM1+SfUAfR256dxa5wA1GIncmSDjl
         OI7oQKW0zXtU0FtXTohHI/8UgKuklHzFZoflg=
MIME-Version: 1.0
In-Reply-To: <4DF6CC58.8050601@jp.fujitsu.com>
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>
	<4df13cea27302b7ccf@agluck-desktop.sc.intel.com>
	<20110612223840.GA23218@aftab>
	<BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>
	<4DF5C36A.1040707@redhat.com>
	<20110613095521.GA26316@aftab>
	<4DF5F729.4060609@redhat.com>
	<20110613124003.GA27918@aftab>
	<4DF606C9.90308@redhat.com>
	<20110613151208.GA29045@aftab>
	<4DF63B7A.1030805@redhat.com>
	<BANLkTinUEqRni2u0DaMfSc45b3DmMMyYvA@mail.gmail.com>
	<4DF6CC58.8050601@jp.fujitsu.com>
Date: Mon, 13 Jun 2011 20:09:42 -0700
Message-ID: <BANLkTimqxBMS7KxMEJho4y+Mg+GJ=6a-vA@mail.gmail.com>
Subject: Re: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
From: Tony Luck <tony.luck@gmail.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 7:50 PM, Hidetoshi Seto
<seto.hidetoshi@jp.fujitsu.com> wrote:
> I've made small patches to clear things. Could you take a look?
>
> These are based on my cleanup patch set:
> https://lkml.org/lkml/2011/6/7/677

Boris pointed me to your v2 patchset - I got about halfway through it
today. It all looks
really good.  I got stuck trying to test the new irq_work() pieces
[because my injection
system is not working well today]. I will try again tomorrow.

-Tony
