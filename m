Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935Ab0JGOII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 10:08:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48644 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab0JGOIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 10:08:06 -0400
Message-ID: <4CADD442.4050706@zytor.com>
Date: Thu, 07 Oct 2010 07:08:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: patch disabling use of PSE on Atom CPUs with a certain	 erratum
References: <4CADAB3A020000780001B30A@vpn.id2.novell.com> <4CADCF23.5070800@zytor.com> <4CADEED9020000780001B44F@vpn.id2.novell.com>
In-Reply-To: <4CADEED9020000780001B44F@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2010 07:01 AM, Jan Beulich wrote:
>>
>> Those Atoms don't have 64-bit support.
> 
> That's different from what I found looking around on the web.
> 

Do tell...

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

