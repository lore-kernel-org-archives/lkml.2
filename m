Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0ELG0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 02:26:54 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:54211 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab0ELG0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 02:26:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=epwi79+YUnd+xwrCvH3JSfwAgrMaXOdWEQYvdRNQ/cQzF41KOla1aZ+A2of8Fs1CYH
         paFS1AnFwQSj3KaME9gVxySJW3TzTPfy4L7v96NvHs+LQ1KXAR8WB3Apzl2ilhjJIlk3
         5Nupujb7osVCdRxriu3W4P/YL/jlSvrcvDxpw=
Date: Wed, 12 May 2010 14:30:42 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Florian Mickler <florian@mickler.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] scripts/get_maintainer.pl: add
 .get_maintainer.conf default options file
Message-ID: <20100512063042.GB5718@cr0.nay.redhat.com>
References: <cover.1273466698.git.joe@perches.com>
 <61106722b46cbf707d3e2641765aae2db93b6ea7.1273466698.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61106722b46cbf707d3e2641765aae2db93b6ea7.1273466698.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 09, 2010 at 09:56:03PM -0700, Joe Perches wrote:
>Allow the use of a .get_maintainer.conf file to control the
>default options applied when scripts/get_maintainer.pl is run.
>
>.get_maintainer.conf can contain any valid command-line argument.
>
>File contents are prepended to any additional command line arguments.
>
>Multiple lines may be used, blank lines ignored, # is a comment.

Do we really have to do this? This looks odd to me.

If the user of get_maintainer.pl uses some long command line
arguments, to save his input, he should use bash aliases, not
configure files. I never see configure files used like this.

Also, it doesn't worthy a configure file for such a script like
get_maintainer.pl.
