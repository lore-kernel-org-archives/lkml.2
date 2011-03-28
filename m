Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1C1PXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:23:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab1C1PXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:23:38 -0400
Date: Mon, 28 Mar 2011 11:23:27 -0400
From: David Teigland <teigland@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@linux.intel.com>,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH] dlm: Remove superfluous call to recalc_sigpending()
Message-ID: <20110328152327.GA16080@redhat.com>
References: <1300975007-1944-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300975007-1944-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 01:56:47PM +0000, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@linux.intel.com>
> 
> recalc_sigpending() is called within sigprocmask(), so there is no
> need call it again after sigprocmask() has returned.

Thanks, pushed to dlm.git next.
Dave

