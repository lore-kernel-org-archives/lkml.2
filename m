Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab0LGJai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:30:38 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53803 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab0LGJah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:30:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Guhrvl9PzNPMGPCBCOWPxzvNkN/eUPlIM28oIrZ7KqwRk5HcO4UZgqKjmGZduwrwrU
         RKj/HSIBf9eHDF1PAqgZ1AVJPWZhHWTJ+nggdjkorCj7FFl9IEbreEu3fDKk3/XlIXWb
         Q1MjSoEClM97wPApFkd/Rxeepz8BnrN4O6Qi8=
Date: Tue, 7 Dec 2010 01:30:30 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Trilok Soni <tsoni@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org
Subject: Re: [RFC v1 PATCH 2/6] input: pm8058_keypad: Qualcomm PMIC8058
 keypad controller driver
Message-ID: <20101207093029.GB22416@core.coreip.homeip.net>
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org>
 <1289393281-4459-3-git-send-email-tsoni@codeaurora.org>
 <20101206181427.GA18567@core.coreip.homeip.net>
 <4CFDFCC3.5000700@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CFDFCC3.5000700@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 02:52:11PM +0530, Trilok Soni wrote:
> Hi Dmitry
> 
> On 12/6/2010 11:44 PM, Dmitry Torokhov wrote:
> > Hi Trilok,
> > 
> > On Wed, Nov 10, 2010 at 06:17:57PM +0530, Trilok Soni wrote:
> >> Add Qualcomm PMIC8058 based keypad controller driver
> >> supporting upto 18x8 matrix configuration.
> >>
> > 
> > Looks very good, just a couple of small things:
> 
> Thanks for reviewing same revision of the patch again :)
> 

Oops ;) Did I need to review something else from you then? I have a
nagging feeling that I have a patch outstanding...

-- 
Dmitry
