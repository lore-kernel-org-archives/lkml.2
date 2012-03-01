Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382Ab2CAWz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 17:55:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758356Ab2CAWzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 17:55:18 -0500
Date: Thu, 1 Mar 2012 17:55:12 -0500
From: Dave Jones <davej@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: error fetching the cpufreq-current tree
Message-ID: <20120301225512.GA24758@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20120302094542.270f421effd7a241d10a3852@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302094542.270f421effd7a241d10a3852@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 09:45:42AM +1100, Stephen Rothwell wrote:
 > Hi Dave,
 > 
 > Fetching the cpufreq-current tree produces this warning:
 > 
 > fatal: Couldn't find remote ref refs/heads/fixes

Forgot to push the empty branch. Should be fixed now.

thanks,

	Dave
 
