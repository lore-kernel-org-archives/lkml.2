Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab1F3Xxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 19:53:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41226 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab1F3Xxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 19:53:51 -0400
Message-ID: <4E0D0C24.3010605@gmail.com>
Date: Fri, 01 Jul 2011 07:52:04 +0800
From: Asias He <asias.hejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, penberg@kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tools/kvm] kvm tools: Make default host ip address to 192.168.33.1
References: <tip-6ba4b23023bfc6f7659e5f575845d62c5cc5a1ae@git.kernel.org> <4E0CE855.1000402@zytor.com>
In-Reply-To: <4E0CE855.1000402@zytor.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2011 05:19 AM, H. Peter Anvin wrote:
> On 06/30/2011 02:09 PM, tip-bot for Asias He wrote:
>>  #define DEFAULT_GUEST_MAC	"00:15:15:15:15:15"
> 
> If you're going to hard-code a MAC at least please have the decency to
> set bit 1 in the first octet.

Hi, Peter

I will set the Universal/Local bit.

Thanks.

-- 
Best Regards,
Asias He
