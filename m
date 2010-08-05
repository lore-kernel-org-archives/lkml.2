Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995Ab0HEIq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 04:46:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759983Ab0HEIqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 04:46:54 -0400
Message-ID: <4C5A7A7A.9040909@redhat.com>
Date: Thu, 05 Aug 2010 11:46:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Anjali Kulkarni <anjali@juniper.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Freebsd image from Qemu hangs on booting in KVM
References: <50B3A5560BA4D74CADEC55A48B4641B23D5AD270D6@EMBX01-HQ.jnpr.net>
In-Reply-To: <50B3A5560BA4D74CADEC55A48B4641B23D5AD270D6@EMBX01-HQ.jnpr.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/05/2010 05:20 AM, Anjali Kulkarni wrote:
> Hi,
>
> I have a problem similar to the one seen on this list before - when I boot my freebsd based(but modified) image in Qemu with KVM on CentOS, then after almost booting completely, the image hangs - just before the login prompt is seen. If I do not have KVM ie plain CenOS with Qemu, then this issue does not occur. Has anyone seen this before and any ideas how to debug this?

First step is to issue 'info registers' and 'x/30i $eip-20' from the 
monitor when it hangs (qemu -monitor stdio makes cut'n'paste easier).

-- 
error compiling committee.c: too many arguments to function

