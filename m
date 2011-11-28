Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1K1FpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 00:45:08 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60120 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751430Ab1K1FpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 00:45:06 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <D6D887BA8C9DFF48B5233887EF04654109F12EC332@bgsmsx502.gar.corp.intel.com>
References: <1322280877.6458.3.camel@phoenix> <D6D887BA8C9DFF48B5233887EF04654109F12EC332@bgsmsx502.gar.corp.intel.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 28 Nov 2011 13:44:43 +0800
Message-ID: <CAF+7xWnmce=F97Txc+SENzQxzdQdLKHyf619W46Yg1j9HAj_aw@mail.gmail.com>
Subject: Re: [PATCH] platform-drivers-x86: convert drivers/platform/x86/* to
 use module_platform_driver()
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Hong" <hong.liu@intel.com>, Daniel Drake <dsd@laptop.org>,
        Matthew Garrett <mjg@redhat.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/28 R, Durgadoss <durgadoss.r@intel.com>:
> Hi,
>
> Thanks for the nice clean up for intel_mid_thermal.c
>
> From which kernel version is this new macro supported ?
>
module_platform_driver() is already in current Linus's tree ( linux-3.2 rcX)
Regards,
Axel
