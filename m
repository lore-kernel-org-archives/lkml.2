Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab3AHJOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 04:14:25 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:61211 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab3AHJOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 04:14:23 -0500
Date: Tue, 8 Jan 2013 10:14:14 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: christophe.leroy@c-s.fr
Cc: jic23@cam.ac.uk, linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        patrick.vasseur@c-s.fr
Subject: Re: [PATCH] IIO ADC support for AD7923
Message-ID: <20130108091414.GA28404@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <201301080842.r088gKWO031124@localhost.localdomain>
References: <201301080842.r088gKWO031124@localhost.localdomain> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config AD7923

I wonder if IIO config symbols should have IIO_ in their name, so
people looking at config files knows what they actually are.
Actually, all USB drivers have USB in their config name, which is
useful even if e.g. "PL2303" cannot be but USB.

On the other hand, AD7923 and all the others can well be driven by
something else than IIO, even if currently this is the only mainstream
option. Here comedi made the right choice, and all their symbols are
in the CONFIG_COMEDI_ name space.

Thanks
/alessandro
