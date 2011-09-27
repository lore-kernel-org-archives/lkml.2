Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab1I0U3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:29:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59851 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308Ab1I0U3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:29:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Luming Yu <luming.yu@gmail.com>
Subject: Re: PME via interrupt or SCI mechanism?
Date: Tue, 27 Sep 2011 22:32:06 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        robert.moore@intel.com, Shaohua Li <shaohua.li@intel.com>
References: <20110912171003.GA7939@xanatos> <20110926234835.GA9551@xanatos> <CAJRGBZxTakHn-BQTrLXsccriGAOERDox0pORMP+vrazzqAA-kQ@mail.gmail.com>
In-Reply-To: <CAJRGBZxTakHn-BQTrLXsccriGAOERDox0pORMP+vrazzqAA-kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109272232.06389.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 27, 2011, Luming Yu wrote:
> On Tue, Sep 27, 2011 at 7:48 AM, Sarah Sharp
> <sarah.a.sharp@linux.intel.com> wrote:
> >
> > Ok.  Do you have suggestions for any tests I can run or debugging
> > statements to add?  I'm really not an ACPI expert and I've been
> > basically fumbling in the dark.
> 
> The following patch from Shaohua might be useful to help debugging the problem.
> http://kerneltrap.org/mailarchive/linux-usb/2009/7/30/6251245

You probably don't realize that the patch is neither applicable nor
relevant any more, but it would be nice to check that before
recommending it to anyone, don't you think?

Rafael
