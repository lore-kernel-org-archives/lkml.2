Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab2CEPis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:38:48 -0500
Received: from mga10.intel.com ([192.55.52.92]:61859 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750812Ab2CEPir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:38:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dan.j.williams@intel.com designates 10.60.22.10 as permitted sender) smtp.mail=dan.j.williams@intel.com
MIME-Version: 1.0
In-Reply-To: <4F54DB1F.3080000@debian.org>
References: <CAJ75kXZ-2vWZpG7Uz3firg6ew4y_DdorXotkAkUGSK0GWLMUQQ@mail.gmail.com>
	<20120127144737.GA27750@andromeda.dapyr.net>
	<20120219223125.GA820@burratino>
	<20120220181618.GD17566@burratino>
	<4F4891B8.9050008@goirand.fr>
	<20120302055715.GA692@burratino>
	<CABE8wwt8Lngy=-iL7QGCofy0nW5-q4VJDS_ovEr96fGdYm72ew@mail.gmail.com>
	<20120302162159.GB31683@wavehammer.waldi.eu.org>
	<CABE8wwtrMEAMw3sJgb8XWQWn_N=YOPzhNbLL0kzMKLhv7xt5=A@mail.gmail.com>
	<20120302175719.GA1468@wavehammer.waldi.eu.org>
	<CABE8wwvd-R1VkyFL-eZYDB9O05zyWkVQ8pXuMb8GcdAW=5qT3A@mail.gmail.com>
	<4F54DB1F.3080000@debian.org>
Date: Mon, 5 Mar 2012 07:38:26 -0800
Message-ID: <CABE8wwtOwgiYwb-_g-3Fg_QH6ph7LEPdkcOff94inDFvs9kwxA@mail.gmail.com>
Subject: Re: [Pkg-xen-devel] ioatdma: Boot process hangs then reboots when
 using Xen + Linux 3.2
From: Dan Williams <dan.j.williams@intel.com>
To: Thomas Goirand <zigo@debian.org>
Cc: Jonathan Nieder <jrnieder@gmail.com>, xen-devel@lists.xensource.com,
        pkg-xen-devel@lists.alioth.debian.org,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        linux-kernel@vger.kernel.org, William Dauchy <wdauchy@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 7:26 AM, Thomas Goirand <zigo@debian.org> wrote:
> I will do my best to provide it ASAP. Should I compile with BUG_ON so
> you see it crashing, as per the original code, or just with WARN_ON, so
> you also see further things in dmesg?

Yes, replacing with a WARN_ON might allow it to skid after the crash
and give a bit more information.

Thank you for grabbing this info.

--
Dan
