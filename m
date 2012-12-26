Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab2LZH43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 02:56:29 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42621 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2LZH41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 02:56:27 -0500
MIME-Version: 1.0
In-Reply-To: <20121224193038.GA7786@roeck-us.net>
References: <50D81465.9060802@mose.org.uk>
	<20121224193038.GA7786@roeck-us.net>
Date: Wed, 26 Dec 2012 09:56:26 +0200
X-Google-Sender-Auth: D5zdwSydTG7twZNB-n_F3aIJ6Co
Message-ID: <CA+i0qc6K-dXDFbTLaxH7VUMOsGKCpUr_yG-1-1vis+D4wEcJDA@mail.gmail.com>
Subject: Re: [lm-sensors] RFC: Intel QST driver
From: Tomas Winkler <tomas.winkler@intel.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "Simon J. Rowe" <srowe@mose.org.uk>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Samuel Ortiz <samuel.ortiz@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > 4) I don't believe the MEI (HECI) implementation that Intel have
> > already submitted to the mainline kernel is usable by other kernel
> > modules. I have re-implemented it in a way that is accessible to
> > either the kernel or userspace.
> >
> 2.6.39 does not include the new mei driver, so I don't think you can make
> that claim.
>
 We are working on adding possibility of stacking another drivers
above the MEI
in these days. I cannot commit to specific time line yet but it is on the way.


Thanks
Tomas
