Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2BEVEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 16:04:44 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:37567 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751709Ab2BEVEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 16:04:42 -0500
Date: Sun, 5 Feb 2012 21:32:15 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] cpupower tool: allow building output to be in a
 separate directory
Message-ID: <20120205203215.GB11621@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Franck Bui-Huu <fbuihuu@gmail.com>, linux-kernel@vger.kernel.org
References: <1328094500-19393-1-git-send-email-fbuihuu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328094500-19393-1-git-send-email-fbuihuu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Feb 01, 2012 at 12:08:17PM +0100, Franck Bui-Huu wrote:
> This small patchset gives to the user the ability to build cpupower
> tool even if the source code is stored in a read-only location.
> 
> Patches #1 and #2 are just minor cleanup in order to ease patch #3
> which adds the functionnality.

Thanks for your patches. I've applied all of them and will push them in the
next merge window.

Best,
	Dominik
