Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab1FIPXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 11:23:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36873 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab1FIPXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 11:23:52 -0400
Message-ID: <4DF0E584.2030101@zytor.com>
Date: Thu, 09 Jun 2011 08:23:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Jones <pjones@redhat.com>
CC: Matthew Garrett <mjg@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: CONFIG_EFI should select CONFIG_RELOCATABLE
References: <1307629964-31658-1-git-send-email-mjg@redhat.com> <4DF0DAAB.7010005@zytor.com> <4DF0DB8D.5080207@redhat.com>
In-Reply-To: <4DF0DB8D.5080207@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 07:41 AM, Peter Jones wrote:
>>
>> Can we make this a depends on instead of select?
> 
> Seems weird to me - when you're configuring the kernel, you're more likely
> to know that you want EFI than to remember that that requires relocation.
> 

Yes, but "select" is handled very poorly by Kconfig.

	-hpa
