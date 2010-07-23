Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab0GWAqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 20:46:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39298 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab0GWAqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 20:46:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=u9cURnrjOB6Df04RHEBhFltApko/9PoSbDwOU5zmUanuONsDRAWsbXl/4sTDos4CqT
         NY5Zv4nXNXUyX8aUemMEyk1fTswf6AW6gAJDTU75q0ACJJY4L3jSn4k8GO0Jynu2f9Mh
         9DKuxwM0vMQvs3XamcCGK0UC2DoNwTfAbMLeY=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20100722151106.GD25002@srcf.ucam.org>
References: <1278897325.6563.7.camel@mola> <20100722151106.GD25002@srcf.ucam.org>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 23 Jul 2010 08:45:39 +0800
Message-ID: <AANLkTingKYmfwx9ASUCvxn08OAEjnhyLFGUHHxgRBNBw@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: fix hotplug_disabled module_param 
	permissions
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/22 Matthew Garrett <mjg59@srcf.ucam.org>:
> I think I've got all of your patches merged now, but let me know if I've
> missed any. They should be in my linux-next branch.

hi Matthew,
Thanks for merging the patches.

Below 3 patches are missing:
[PATCH] asus-laptop: fix asus_input_init error path
        http://lkml.org/lkml/2010/7/5/21
[PATCH] dell-laptop: make dell_laptop_i8042_filter() static
        http://lkml.org/lkml/2010/7/5/69
[PATCH] msi-wmi: make needlessly global symbols static
        http://lkml.org/lkml/2010/7/8/66

Regards,
Axel
