Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab0KKAyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:54:14 -0500
Received: from kroah.org ([198.145.64.141]:35026 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757568Ab0KKAyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:54:12 -0500
Date: Wed, 10 Nov 2010 16:48:53 -0800
From: Greg KH <greg@kroah.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        torvalds@linux-foundation.org, kees.cook@canonical.com,
        akpm@linux-foundation.org
Subject: Re: [Security] [PATCH v3] Restrict unprivileged access to kernel
	syslog
Message-ID: <20101111004853.GD22463@kroah.com>
References: <1289431735.3847.9.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289431735.3847.9.camel@dan>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 06:28:55PM -0500, Dan Rosenberg wrote:
> CC: stable <stable@kernel.org>

Like Andrew pointed out, this is not stable material.  Please go read
Documentation/stable_kernel_rules.txt to explain what is acceptable for
the stable kernel trees (hint, new features like this one is not.)

thanks,

greg k-h
