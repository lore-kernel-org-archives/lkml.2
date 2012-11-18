Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab2KRB5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 20:57:19 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:47528 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab2KRB5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 20:57:18 -0500
Date: Sat, 17 Nov 2012 17:53:48 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: dragos.tatulea@intel.com
Cc: ccross@android.com, keescook@chromium.org, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        octavian.purdila@intel.com
Subject: Re: [PATCH v3 2/9] pstore: add debugfs support for causing dumps and
 panics
Message-ID: <20121118015348.GB5556@lizard.sbx05977.paloaca.wayport.net>
References: <1350558367-31801-1-git-send-email-dragos.tatulea@intel.com>
 <1350558367-31801-3-git-send-email-dragos.tatulea@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1350558367-31801-3-git-send-email-dragos.tatulea@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 02:06:00PM +0300, dragos.tatulea@intel.com wrote:
> From: Adrian Hunter <adrian.hunter@intel.com>
> 
> There are 2 debugfs files:
> 
> 	pstore/dump	writing a kmsg dump reason code
> 			will cause a dump to persistent
> 			storage
> 
> 	pstore/panic	writing anything will cause
> 			a panic
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---

Um... how is different from /proc/sysrq-trigger?.. At least sysrq has
'panic', and I guess it would be better to extend it if we need something
more than this.

Thanks,
Anton.
