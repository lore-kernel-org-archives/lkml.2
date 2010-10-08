Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab0JHMJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 08:09:33 -0400
Received: from imr3.ericy.com ([198.24.6.13]:41493 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756689Ab0JHMJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 08:09:32 -0400
Date: Fri, 8 Oct 2010 05:08:57 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Chen Gong <gong.chen@linux.intel.com>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] hwmon: uniform the init style of pkgtemp
Message-ID: <20101008120857.GA24789@ericsson.com>
References: <1286517216-15640-1-git-send-email-gong.chen@linux.intel.com>
 <1286517216-15640-2-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1286517216-15640-2-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 01:53:35AM -0400, Chen Gong wrote:
> pkgtemp is derived from coretemp, so some reasonable
> logics should be applied onto pkgtemp, too. Such as
> the init logic here.
> 
> Signed-off-by: Chen Gong <gong.chen@linux.intel.com>

Applied.
