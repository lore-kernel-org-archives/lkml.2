Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab0HCNxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:53:14 -0400
Received: from mx4.sophos.com ([74.202.89.161]:43070 "EHLO mx4.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949Ab0HCNxN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:53:13 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35 hangs on early boot in KVM
Date: Tue, 3 Aug 2010 14:53:08 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
References: <201008031028.57263.tvrtko.ursulin@sophos.com> <201008031045.02979.tvrtko.ursulin@sophos.com>
In-Reply-To: <201008031045.02979.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Message-ID: <201008031453.09023.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 03/08/2010 14:53:10,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 03/08/2010 14:53:11,
	Serialize complete at 03/08/2010 14:53:11
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 Aug 2010 10:45:02 Tvrtko Ursulin wrote:
> On Tuesday 03 Aug 2010 10:28:56 Tvrtko Ursulin wrote:
> > I have basically built 2.6.35 with make oldconfig from a working 2.6.34.
> > Latter works fine in kvm while 2.6.35 hangs very early. I see nothing
> > after grub (have early printk and verbose bootup enabled), just a
> > blinking VGA cursor and CPU at 100%.
> >
> > Config is attached. Any ideas what options I could toggle to debug this?
> > I tried gzip instead of lzma but it isn't that.
>
> Just discovered I did not removed the quiet boot option, what I thought I
> have.. with that removed I see that it hangs just after "Booting the
> kernel." line.

Bisection so far:

good: 3de29cab1f8d62db557a4afed0fb17eebfe64438
bad: 537b60d17894b7c19a6060feae40299d7109d6e7

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
