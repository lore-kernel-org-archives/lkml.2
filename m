Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1BPOcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 09:32:01 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:55478 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755750Ab1BPOb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 09:31:59 -0500
Date: Wed, 16 Feb 2011 09:31:32 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [000/272] 2.6.37.1-stable review
Message-ID: <20110216143132.GA1928@elliptictech.com>
References: <20110216001559.GA31413@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216001559.GA31413@kroah.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-15 16:15 -0800, Greg KH wrote:
> Note, there are still some patches that people have sent me that did not
> make it to this release.  They will show up in the next one, this one is
> big enough, as I'm sure you will agree.

Hi Greg,

Commit c42988012ad9 ("drm/nouveau: Only select ACPI_VIDEO if its
dependencies are met") is needed to fix a build failure on 2.6.37.

I don't see it in your list, and it seems like the patch wasn't Cc'd to
stable, so I just want to make sure you know about it.

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
