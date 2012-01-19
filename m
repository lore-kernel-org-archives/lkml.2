Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab2ASBXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:23:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab2ASBXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:23:18 -0500
Date: Wed, 18 Jan 2012 17:21:30 -0800
From: Greg KH <gregkh@suse.de>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Denis Turischev <denis@compulab.co.il>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH] pch_phub: add message to notify installing pch_phub
Message-ID: <20120119012130.GA6050@suse.de>
References: <1326935267-4077-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326935267-4077-1-git-send-email-tomoya.rohm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 10:07:47AM +0900, Tomoya MORINAGA wrote:
> Currently, a user who wants to install pch_phub, the user can't know whether
> the driver is installed or not from log of kernel ring buffer.
> Of course, though seeing sysfs files, the user can know the installing,
> kernel message is useful better than seeing sysfs files.
> 
> So, this patch adds logs.

No, I'm going to reject this, we have been _removing_ these types of
garbage messages from drivers, please don't add new ones, it is
pointless.

greg k-h
