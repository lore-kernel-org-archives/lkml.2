Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab1CKISw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 03:18:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33319 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1CKISv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 03:18:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CJKJYe3fPN7pCpVShB6dWrj1+oPNP/gpzJdyKPHalrrCE2WQ5crYWxIrW7gju55vAY
         yY9gjqUuNm1tr1dx+FEnNPVe9B19G2ZwTPbgt4cBvYlpCalenCc+0dve+r6BBsXyFfN7
         BQtNWdP0kb6ohkDggkeTG+JToxFyoRBVw5x/U=
Date: Fri, 11 Mar 2011 00:18:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        micki@n-trig.com, rydberg@euromail.se, chatty@enac.fr
Subject: Re: [PATCH 1/2] hid-ntrig: sysfs nodes for modes
Message-ID: <20110311081843.GE10807@core.coreip.homeip.net>
References: <1299829072-19489-1-git-send-email-rafi@seas.upenn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299829072-19489-1-git-send-email-rafi@seas.upenn.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 02:37:51AM -0500, Rafi Rubin wrote:
> Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
> 
> ---
> 
> If the code is there, might as well expose a friendly interface to the
> user.

The bigger question is should the user care? If we can make the device
work well without user intervention then we should not really expose
extra attributes.

Thanks.

-- 
Dmitry
