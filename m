Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1DTQfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:35:13 -0400
Received: from imr4.ericy.com ([198.24.6.8]:60179 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab1DTQfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:35:11 -0400
Date: Wed, 20 Apr 2011 09:34:19 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH v2] misc: Driver for Silicon Labs Si570 and compatibles
Message-ID: <20110420163418.GA22806@ericsson.com>
References: <1303248968-5069-1-git-send-email-guenter.roeck@ericsson.com>
 <4DAEA618.4040801@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4DAEA618.4040801@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 05:23:36AM -0400, Jonathan Cameron wrote:
> On 04/19/11 22:36, Guenter Roeck wrote:
> > This driver adds support for Si570, Si571, Si598, and Si599
> > programmable XO/VCXO.
> cc'd Michael Hennerich, as I would imagine this has some similarities to the DDS
> chips we have in IIO (be it a very simple one).
> 
> Guenter, what is your use case for this part?
> 
It is used to generate a configurable serdes clock. The clock is either
left alone at its default, or configured during system startup.

What is the use case for dds devices ?

Thanks,
Guenter
