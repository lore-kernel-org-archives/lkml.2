Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab0JRO1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:27:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51798 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab0JRO1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:27:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r9OFtKixWMqllTTHvbXOVeMhd+hHCFbp+jNEPy8QtayyY16qic7+NbMg/x+Zm7YKsB
         I2Org5EtM+uUhMxCZERuQSBAvWvypN4C1WJz20c6ESW1m7SkUO0wGH1bMxLqc7Flj6Xg
         EhXHTL8BpXjdB6pATtvab+och2RykhnQggNG0=
Date: Mon, 18 Oct 2010 16:27:48 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/6] [RFC] posix clocks: dynamic clock ids.
Message-ID: <20101018142748.GA5767@riccoc20.at.omicron.at>
References: <1287189535-24649-1-git-send-email-john.stultz@linaro.org>
 <1287189535-24649-2-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287189535-24649-2-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 05:38:50PM -0700, John Stultz wrote:
> From: Richard Cochran <richardcochran@gmail.com>
> 
> This patch augments the POSIX clock code to offer a dynamic clock
> creation method. Instead of registering a hard coded clock ID, modules
> may call create_posix_clock(), which returns a new clock ID.
> 
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
> 
> This patch still has un-addressed lifetime issues pointed out by
> Alan Cox. More work is needed here, but for now this provides the
> functionality needed for the following patches.

I am working on a fully dynamic clock implementation in the style
suggested by Alan. Using it would change some details in this RTC
patch series, but not the general idea.

Should I post the dynamic clock stuff all by itself for review?

(The entire patch series including the PTP hardware clocks will take
a bit longer.)

Richard
