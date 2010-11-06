Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab0KFT5N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 15:57:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36909 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab0KFT5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 15:57:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MTHRIv6ttePlX0oLD4wS49xTbk6coKUUFNqiLmo5uJakhaExgBO2ZfmxL5R6Ywy0NV
         8dYkvhlN6cZVqoK+00TVsXfoHjkQPl+2DhSFUoIzDbbX3FPNIDSCpbHo8qVc/NQYufoq
         qqCAkSi7jvvTk5/0vJmaIu/eKolPnKRM3QvKU=
Date: Sat, 6 Nov 2010 12:57:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tracey Dent <tdent48227@gmail.com>
Cc: jkosina@suse.cz, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        spbnick@gmail.com, chatty@enac.fr
Subject: Re: [PATCH 1/2] Drivers: hid: Makefile: Cleaned up Makefile
Message-ID: <20101106195705.GA26765@core.coreip.homeip.net>
References: <1289070464-3392-1-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289070464-3392-1-git-send-email-tdent48227@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tracey,

On Sat, Nov 06, 2010 at 03:07:43PM -0400, Tracey Dent wrote:
> Changed Makefile to use <modules>-y instead of <modules>-objs.
> 

Changelog normally should say why something has been done as what has
been done is pretty clear from the patch itself.

Thanks.

-- 
Dmitry
