Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0LGJRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:17:03 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:51888 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab0LGJRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:17:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GVBL9DOqKKrgJFob2ULnAp+6QhFUecsnSf5G0Rzsvl0lh5ZNmhA6/KYKqWtjPHKb22
         6jTuJwhlxMDiadG1EjWprEXvYCZxPZE9lid/RHiTzdOUHIPQ10QAcZIHuFrEg6va9ojA
         EXFUtwT5YrZdu9O9GARz9+4oWxKXAnBmG1cQo=
Date: Tue, 7 Dec 2010 01:16:53 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ping Cheng <pingc@wacom.com>,
        Chris Bagwell <chris@cnpbagwell.com>
Subject: Re: [RFC][PATCH] input: Introduce device information ioctl
Message-ID: <20101207091653.GA22416@core.coreip.homeip.net>
References: <1291706726-8835-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291706726-8835-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Tue, Dec 07, 2010 at 08:25:26AM +0100, Henrik Rydberg wrote:
> Today, userspace sets up an input device based on the data it emits.
> This is not always enough; a tablet and a touchscreen may emit exactly
> the same data, for instance, but the former should be set up with a
> pointer whereas the latter does not need to. Recently, a new type of
> touchpad has emerged where the buttons are under the pad, which changes
> handling logic without changing the emitted data. This patch introduces
> a new ioctl, EVIOCGDEVINFO, which allows userspace to extract information
> about the device resulting in proper setup.

If we agree that the new ioctl is suitable we'llalso need to wireit up
through sysfs. Also, can we keep all definitions to INPUT_ namespace?

Thanks.

-- 
Dmitry
