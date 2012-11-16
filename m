Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2KPP4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:56:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33697 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab2KPP4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:56:05 -0500
Message-ID: <50A661F5.6040301@zytor.com>
Date: Fri, 16 Nov 2012 07:55:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Zachary Amsden <zach@vmware.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 1/9] x86, boot: Move lldt/ltr out of 64bit only path
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org> <1353055989-31939-2-git-send-email-yinghai@kernel.org>
In-Reply-To: <1353055989-31939-2-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 12:53 AM, Yinghai Lu wrote:
> 
> Also it push down startup_64 to 0x208.
> 

NAK.  0x200 is an ABI, you can't change it.

	-hpa


