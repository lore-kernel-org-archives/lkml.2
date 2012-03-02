Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab2CBQ2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 11:28:15 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:50843 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab2CBQ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 11:28:09 -0500
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2012 11:28:09 EST
Date: Fri, 2 Mar 2012 17:21:59 +0100
From: Bastian Blank <waldi@debian.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, xen-devel@lists.xensource.com,
        pkg-xen-devel@lists.alioth.debian.org,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        linux-kernel@vger.kernel.org, William Dauchy <wdauchy@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [Pkg-xen-devel] ioatdma: Boot process hangs then reboots when
 using Xen + Linux 3.2
Message-ID: <20120302162159.GB31683@wavehammer.waldi.eu.org>
Mail-Followup-To: Dan Williams <dan.j.williams@intel.com>,
	Jonathan Nieder <jrnieder@gmail.com>, xen-devel@lists.xensource.com,
	pkg-xen-devel@lists.alioth.debian.org,
	Maciej Sosnowski <maciej.sosnowski@intel.com>,
	linux-kernel@vger.kernel.org, William Dauchy <wdauchy@gmail.com>,
	Konrad Rzeszutek Wilk <konrad@darnok.org>
References: <CAJ75kXZ-2vWZpG7Uz3firg6ew4y_DdorXotkAkUGSK0GWLMUQQ@mail.gmail.com>
 <20120127144737.GA27750@andromeda.dapyr.net>
 <20120219223125.GA820@burratino>
 <20120220181618.GD17566@burratino>
 <4F4891B8.9050008@goirand.fr>
 <20120302055715.GA692@burratino>
 <CABE8wwt8Lngy=-iL7QGCofy0nW5-q4VJDS_ovEr96fGdYm72ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABE8wwt8Lngy=-iL7QGCofy0nW5-q4VJDS_ovEr96fGdYm72ew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 10:42:44PM -0800, Dan Williams wrote:
> WARN_ON may work, but then kernel may be subject random hangs from missed
> i/o completions.

Why is that? Currently it just dies if was triggered via interrupt and
for some reason no active descriptor was found.

>                   Is xen32 using vt-d?

Yes. Xen can use VT-D.

>                                         Just wondering if writes from ioat
> device are getting misdirected.

How do VT-D and ioat interact?

Bastian

-- 
Too much of anything, even love, isn't necessarily a good thing.
		-- Kirk, "The Trouble with Tribbles", stardate 4525.6
