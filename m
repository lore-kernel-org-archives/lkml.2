Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab0ETQxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:53:15 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:34364 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab0ETQxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:53:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dVJOehswVbmx3Iqyl72eilAAQNUiZV9T9E9CrZskL0T9Uyw/7hFTVcsZKr5ZCbVE6m
         cluC5cs7R0Wf/OyLlpW4MavwcJDdEER/6a2bJcwR3NUC30GWvNdcVr9PK3cWvhuYY4t7
         2qOaym+VBP5p6hB/filNRzUEHsOWdrA2PKApk=
Date: Thu, 20 May 2010 09:53:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@linux.intel.com>, Jacob Pan <jacob.jun.pan@intel.com>
Subject: Re: [PATCH] input: do not select i8042 for x86 mid
Message-ID: <20100520165308.GC20861@core.coreip.homeip.net>
References: <1274124916-23668-1-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274124916-23668-1-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 12:35:16PM -0700, Jacob Pan wrote:
> From: Jacob Pan <jacob.jun.pan@intel.com>
> 
> Moorestown does not have i8042 based keyboard controller, so give
> an option to deselect i8042 for non-pc mid
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

Applied, thanks Jacob.

-- 
Dmitry
