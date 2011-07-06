Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab1GGAiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:38:01 -0400
Received: from ozlabs.org ([203.10.76.45]:53649 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab1GGAiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:38:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: module: sysfs - add 'uevent' file to allow coldplug
In-Reply-To: <CAPXgP117WLtEX7ecrr9rs7HP0ZYkh25JmKbRj7YRuvGVw359PA@mail.gmail.com>
References: <1308434431.1050.5.camel@mop> <8739j59zib.fsf@rustcorp.com.au> <BANLkTink8YTe=-Tr5Ax3epiFoFCfzcex7w@mail.gmail.com> <87boxshrwe.fsf@rustcorp.com.au> <BANLkTinL4r3RfNuA5x6=UK4DCSSJNeZw7w@mail.gmail.com> <87r56m8w2b.fsf@rustcorp.com.au> <BANLkTimNpDdp+JBXt0wUjuc0awypJSvXRg@mail.gmail.com> <87fwn18k9h.fsf@rustcorp.com.au> <BANLkTi=v-axftYKJCJ33+9UnfF9NJDAykQ@mail.gmail.com> <BANLkTimmTpcPefmWz=H7+4R6-7o4dZ+hnQ@mail.gmail.com> <87hb72skik.fsf@rustcorp.com.au> <CAPXgP117WLtEX7ecrr9rs7HP0ZYkh25JmKbRj7YRuvGVw359PA@mail.gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Wed, 06 Jul 2011 14:57:08 +0930
Message-ID: <877h7w0yj7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jul 2011 17:56:37 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Mon, Jul 4, 2011 at 07:05, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Fri, 1 Jul 2011 05:07:41 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
> >> On Thu, Jun 23, 2011 at 13:24, Kay Sievers <kay.sievers@vrfy.org> wrote:
> >> > On Thu, Jun 23, 2011 at 02:27, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >> >> On Wed, 22 Jun 2011 12:17:49 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
> >> >>> On Wed, Jun 22, 2011 at 04:00, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >> >> I'd prefer that patch first, I think: it's a sensible cleanup.
> >> >
> >> > You want the patch split up in two? You want to remove the mod
> >> > parameter somehow?
> >>
> >> Can we get these 20 lines of code sorted out please? :)
> >
> > An odd question, since I was waiting for you to do exactly that!
> 
> Oh, I was just waiting for your answer to the earlier question 6 lines
> above here. :)

Yes, but rather than go around again, code seemed simpler.

linux-next says we broke CONFIG_MODULES=n though.

I'll fix that now...

Thanks,
Rusty.
