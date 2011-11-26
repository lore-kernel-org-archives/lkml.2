Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1KZVp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 16:45:58 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35740 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab1KZVp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 16:45:57 -0500
From: Federico Vaga <federico.vaga@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: Re: [RFC PATCH 1/7] Documentation: add docs for drivers/zio
Date: Sat, 26 Nov 2011 22:48:16 +0100
Message-ID: <1754007.WtTkxU3GKd@harkonnen>
User-Agent: KMail/4.7.3 (Linux/3.1.1-2.fc16.x86_64; KDE/4.7.3; x86_64; ; )
In-Reply-To: <20111126200012.GB11421@kroah.com>
References: <cover.1322328073.git.rubini@gnudd.com> <136508309048abae5ff23c5230e9344c51442849.1322328075.git.rubini@gnudd.com> <20111126200012.GB11421@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In data sabato 26 novembre 2011 12:00:12, Greg KH ha scritto:
> On Sat, Nov 26, 2011 at 06:30:20PM +0100, Alessandro Rubini wrote:
> > This is documentation for the beta3 release of zio.
> > The files match commit 7d37663 in git://ohwr.org/misc/zio.git .
> > 
> > We are aware the "modules.txt" file is not correct as it lists files
> > that are not ready. We decided to avoid fixing it for this RFC
> > submission, which won't go upstream anyways.
> 
> I think you are using sysfs files here, yet I don't see any
> Documentation/ABI files describing those sysfs files and how they are to
> be used.  Could you please include them?

Sure, we'll do for the next release.

> thanks,
> 
> greg k-h
-- 
Federico Vaga
