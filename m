Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab0HCOvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 10:51:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab0HCOvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 10:51:11 -0400
Message-ID: <4C582CDC.8050801@redhat.com>
Date: Tue, 03 Aug 2010 17:51:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: 2.6.35 hangs on early boot in KVM
References: <201008031028.57263.tvrtko.ursulin@sophos.com>
In-Reply-To: <201008031028.57263.tvrtko.ursulin@sophos.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/03/2010 12:28 PM, Tvrtko Ursulin wrote:
> I have basically built 2.6.35 with make oldconfig from a working 2.6.34.
> Latter works fine in kvm while 2.6.35 hangs very early. I see nothing after
> grub (have early printk and verbose bootup enabled), just a blinking VGA
> cursor and CPU at 100%.
>

Please copy kvm@vger.kernel.org on kvm issues.

> CONFIG_PRINTK_TIME=y


Try disabling this as a workaround.

-- 
error compiling committee.c: too many arguments to function

