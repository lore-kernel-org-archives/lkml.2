Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0DTNU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 09:20:26 -0400
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:48988 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754666Ab0DTNUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 09:20:22 -0400
X-Greylist: delayed 4652 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2010 09:20:22 EDT
Message-ID: <4BCD97C8.6090406@rsk.demon.co.uk>
Date: Tue, 20 Apr 2010 13:02:16 +0100
From: Richard Kennedy <richard@rsk.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [PATCH 0/4] writeback: tracing and wbc->nr_to_write fixes
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1271731314-5893-1-git-send-email-david@fromorbit.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/04/10 03:41, Dave Chinner wrote:
> This series contains the initial writeback tracing patches from
> Jens, as well as the extensions I added to provide visibility into
> writeback control structures as the are used by the writeback code.
> The visibility given is sufficient to understand what is happening
> in the writeback path - what path is writing data, what path is
> blocking on congestion, etc, and to determine the differences in
> behaviour for different sync modes and calling contexts. This
> tracing really needs to be integrated into mainline so that anyone
> can improve the tracing as they use it to track down problems
> in our convoluted writeback paths.
> 
> The remaining patches are fixes to problems that the new tracing
> highlighted.
> 

Hi Dave,

Thanks for adding tracing to this, it will be really useful.

The fix to write_cache_pages looks really interesting, I'm going to test
it on my machine. Maybe it should be a separate patch to get more
visibility?

Ext4 also multiplies nr_to_write, so will that need fixing too?

regards
Richard
