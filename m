Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030894Ab2CNRVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:21:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57555 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030435Ab2CNRVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:21:08 -0400
Date: Wed, 14 Mar 2012 17:21:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>
Subject: Re: [RESEND PATCH 1/2] MFD: MAX77693: add MAX77693 MFD driver
Message-ID: <20120314172101.GA13393@sirena.org.uk>
References: <4F5EDB01.9070308@samsung.com>
 <D958900912E20642BCBC71664EFECE3E6DD2912D02@BGMAIL02.nvidia.com>
 <CAH9JG2VrNCPMHoy5pUyc7nTzv-B7ucXheMy7PBtVUfaebt=yUA@mail.gmail.com>
 <D958900912E20642BCBC71664EFECE3E6DD2912D10@BGMAIL02.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DD2912D10@BGMAIL02.nvidia.com>
X-Cookie: Be sure each item is properly endorsed.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 11:22:24AM +0530, Venu Byravarasu wrote:
> > So we decide to use legacy way. As regmap is not yet tested. So we
> > summit the current way and revise it later.

> I was under the impression that regmap is stable now. Can you 
> plz let me know, what kind of problems you are seeing with 
> regmap? As I'm also planning to upstream a MFD using regmap 
> very soon, this information will be useful.

Yes, it should be very stable.  Personally my primary development
systems have PMICs which use regmap and most of my work is on regmap
based device so I'll probably notice if there's an issue.
