Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317Ab0JIQny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 12:43:54 -0400
Received: from imr4.ericy.com ([198.24.6.8]:55495 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756521Ab0JIQnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 12:43:53 -0400
Date: Sat, 9 Oct 2010 09:43:10 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Chen Gong <gong.chen@linux.intel.com>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: cleanup useless hotplug related macro definition
Message-ID: <20101009164310.GB29169@ericsson.com>
References: <1286517216-15640-3-git-send-email-gong.chen@linux.intel.com>
 <1286589708-18478-2-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1286589708-18478-2-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 10:01:48PM -0400, Chen Gong wrote:
> CONFIG_HOTPLUG_CPU is used too much in some drivers.
> This patch clean them up.
> 
> Signed-off-by: Chen Gong <gong.chen@linux.intel.com>

Applied.

Thanks,
Guenter
