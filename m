Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab1BQT22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:28:28 -0500
Received: from kroah.org ([198.145.64.141]:34996 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab1BQT2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:28:02 -0500
Date: Thu, 17 Feb 2011 11:23:00 -0800
From: Greg KH <greg@kroah.com>
To: james_p_freyensee@linux.intel.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
Subject: Re: [PATCH 09/12] n_tracesink header file.
Message-ID: <20110217192300.GD29448@kroah.com>
References: <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-4-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-5-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-6-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-7-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-8-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-9-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-10-git-send-email-james_p_freyensee@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297193697-5417-10-git-send-email-james_p_freyensee@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 11:34:54AM -0800, james_p_freyensee@linux.intel.com wrote:
> From: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> This header file allows the n_tracerouter to send it's information
> to the n_tracesink ldisc driver.  It's part of the Intel-Atom
> PTI implementation solution.
> 
> Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> ---
>  include/linux/n_tracesink.h |   32 ++++++++++++++++++++++++++++++++

Why is this in include/linux/ ?

thanks,

greg k-h
