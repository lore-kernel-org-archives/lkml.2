Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab0IBA2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 20:28:18 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40286 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab0IBA2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 20:28:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o78spWeWobuCGh8GCTMjThNN6nVFSfAB2TGF3g/vVOetZ8i8IVrCGKS3fqq2SipKWU
         dskBOaX8U/imbzkT47FxoqamIYskeXzDiHE6W49rn0s9jxGhgudrIjHueG2rAfh0+zje
         yzqS23R2+WMDKFu6SrPW7UZtILYUYV2u8qZ7M=
Date: Wed, 1 Sep 2010 17:28:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Xing Wei <weixing@hanwang.com.cn>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>, jkosina <jkosina@suse.cz>
Subject: Re: [PATCH v3] input: Add support for Hanwang tablet
Message-ID: <20100902002809.GA9157@core.coreip.homeip.net>
References: <201009011455438909077@hanwang.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009011455438909077@hanwang.com.cn>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xing,

On Wed, Sep 01, 2010 at 02:55:44PM +0800, Xing Wei wrote:
> Hi Dmitry, it works well and I really appreciate your work. 
> BTN_3 - BTN_8 & ABS_DISTANCE events are not handled & used in our X system driver by now,
> sorry for my mistake.
>

Just to avoid confusion - are BTN_3 - BTN_8 not used by your X driver or
the hardware does not really report them? Because if it the former then
we should continue reporting them - some other user (as in
program/driver) might be interested in these.

Also, why do you develop your own X driver? Does not X's evdev driver
work properly for you?

Thanks.
 
-- 
Dmitry
