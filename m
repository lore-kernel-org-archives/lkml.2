Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1HKPjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:39:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab1HKPjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:39:08 -0400
Date: Thu, 11 Aug 2011 11:39:04 -0400
From: David Teigland <teigland@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Christine Caulfield <ccaulfie@redhat.com>
Subject: Re: [PATCH 39/41] dlm: Remove another superfluous call to
 recalc_sigpending()
Message-ID: <20110811153904.GA9342@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
 <1313071035-12047-40-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313071035-12047-40-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 02:57:13PM +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> recalc_sigpending() is called within sigprocmask(), so there is no
> need call it again after sigprocmask() has returned. I must have
> missed this call when removing the other recalc_sigpending() in commit
> 4bcad6c1ef53 ("dlm: Remove superfluous call to recalc_sigpending())".

ack

