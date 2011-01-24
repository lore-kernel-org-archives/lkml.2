Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab1AXRFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:05:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33646 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab1AXRFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:05:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jfzAF5ENIJ0b9QwMTTLHOyfzr1jhjEPpXo2gOUvN4Lntv+M0Rn0TISUUrK/Bl4qqhF
         OnRvTh0+/6o+iGmHHSBsvgUgzMa/YmyKN2M5Oo5OtCVOv/PSTGcIvauik42Ex1yoGRvf
         EZ7dfunQMsc2Ivo3qEB80F21ZYizTTfBCjVAI=
Date: Mon, 24 Jan 2011 09:04:58 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-input@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Input: sysrq -- ensure sysrq_enabled and
 __sysrq_enabled are consistent
Message-ID: <20110124170458.GA31066@core.coreip.homeip.net>
References: <1295877972-363-1-git-send-email-apw@canonical.com>
 <1295877972-363-2-git-send-email-apw@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295877972-363-2-git-send-email-apw@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 02:06:12PM +0000, Andy Whitcroft wrote:
> Currently sysrq_enabled and __sysrq_enabled are initialised separatly
> and inconsitantly, leading to sysrq being actually enabled by reported
> as not enabled in sysfs.  The first change to the sysfs configurable
> synchronises these two:
> 
>     static int __read_mostly sysrq_enabled = 1;
>     static int __sysrq_enabled;
> 
> Add a common define to carry the default for these preventing them becoming
> out of sync again.  Default this to 1 to mirror previous behaviour.
> 
> Signed-off-by: Andy Whitcroft <apw@canonical.com>

Applied and will also tag for stable. Thank you Andy.

-- 
Dmitry
