Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1EIKzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 06:55:20 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64428 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1EIKzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 06:55:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iePLl/WBUx14tFZWXKQtgXhJbv9vTa0DsBmgjAv8JYE1Af7loPr6wTJ4VoS+AQfgjo
         aVuEMwAz3e8bZi4lW6uG78uiuHiLrTdZwlSHRVzrT1oH5nxN88cZjyNXa4bH2G0jIZnr
         10Hi3y/cqvVDBKmFioVk8O0KJt+XVoh5HgfQ4=
MIME-Version: 1.0
In-Reply-To: <20110425130757.b4c81a5c.akpm@linux-foundation.org>
References: <A8DC7EA93EFCBD4498E3857AFE65E5F13A3D90EB@IND07.indesign.net>
	<20110425130757.b4c81a5c.akpm@linux-foundation.org>
Date: Mon, 9 May 2011 18:55:18 +0800
Message-ID: <BANLkTi=aDikVm5JbVr=zTqcYczsriVf7Sw@mail.gmail.com>
Subject: Re: [PATCH] w1: Add Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC support.
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Barnes, Clifton A." <cabarnes@indesign-llc.com>,
        "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 4:07 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 20 Apr 2011 19:57:05 +0000
> "Barnes, Clifton A." <cabarnes@indesign-llc.com> wrote:
>
>> Add support for the Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC.
>>
>> Another patch from Haojian Zhuang for this part was recently submitted,
>> but I believe that this implementation is more consistent with other
>> fuel gauge drivers since it uses the power supply interface.
>>
>
> Let's Cc him so that he knows about this patch and has a chance to
> comment upon it and test it (please).
>
>
>
Tested. It works well on my platform. I prefer to use this patch.

Thanks
Haojian
