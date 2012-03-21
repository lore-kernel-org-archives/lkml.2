Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab2CUMjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 08:39:07 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:37933 "EHLO
	homiemail-a41.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757904Ab2CUMjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 08:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=ioINHFH8oByndVMM16FvidSzRxBY1fpOYxhK2lw8kmrTRM5/8SU6GXodYVYeW
	WJ5dEZxVdYWszqfTdcD3QzDwpy56cWZU8AkmRVYskOdN93H21qDnohZzRaBOzUHN
	oclpRKILTmxoqnjvtYYEAnE8IPTjcgntlS5VUkG1nPAFHM=
Message-ID: <4F69CBE6.5010604@shealevy.com>
Date: Wed, 21 Mar 2012 08:39:02 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120321 Thunderbird/11.0
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] Add driver for Apple gmux device
References: <1331926882-22979-1-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1331926882-22979-1-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On 03/16/2012 03:41 PM, Seth Forshee wrote:
> Apple laptops with hybrid graphics have a device named gmux that is used
> for switching between GPUs and backlight control. On many models this is
> the only reliable method for controlling the backlight.
>
> This series adds initial support for the gmux device, along with
> anciallary support for disabling apple_bl when the gmux device is
> detected. Initially only backlight control is supported.
>
>

I've done some basic testing on my MBP 5,3 (just setting a few 
brightness levels, nothing fancy), and it all works, so feel free to add 
my basic

Tested-by: Shea Levy <shea@shealevy.com>

if you wish. Please let me know if you need testing for future gmux 
features.

A few questions:
     * I'm using nouveau, and with the gmux I have both gmux_backlight 
and nv_backlight (which never worked) in /sys/class/backlight, is this 
expected?
     * Is there anything I can do to test the sysfs backlight interface 
besides setting the levels?
     * Besides the sysfs backlight interface, are there any other 
userspace-visible changes your driver makes that I should test?

Cheers,
Shea Levy

