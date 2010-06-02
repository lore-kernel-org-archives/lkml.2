Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab0FBHkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:40:04 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38007 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab0FBHkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:40:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JF6z3RnUYwEg7Ds1dHqvfzMDbc4lDWTF/ca3nYCT6xS6WIN0/iFaetQJBH/XysG7mM
         Yo5uIWXA9OV5QVMpTobO09GMppG+8Cst4eqz45xWXkLvAcNpQxK84jRZ0Q/DVCfqWPNV
         /82g6EGwmidBq2Lp5YxcskfW+NtVWnxKfme50=
Date: Wed, 2 Jun 2010 00:39:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thomas Weber <weber@corscience.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: ads7846: Fix warning about output format
Message-ID: <20100602073955.GH3713@core.coreip.homeip.net>
References: <1275461429-4838-1-git-send-email-weber@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275461429-4838-1-git-send-email-weber@corscience.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 08:50:29AM +0200, Thomas Weber wrote:
> This patch fixes a compiler warning about wrong output format.
> 
> drivers/input/touchscreen/ads7846.c: In function 'ads7846_probe':
> drivers/input/touchscreen/ads7846.c:1167: warning: format '%ld' expects
> type 'long int', but argument 4 has type 'int'
> 
> Introduced by commit 067fb2f648543894ce775082c5636f4c32b99e4f ("Input:
> ads7846 - return error on regulator_get() failure").
> 
> The ERR_PTR returns a long so the variable err needs to be long.

No, int works just as well. I have a patch that simply fixes format
specification.

Thanks.

-- 
Dmitry
