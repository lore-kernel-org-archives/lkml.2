Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934319Ab2J3Tfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:35:30 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:57008 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933900Ab2J3Tf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:35:28 -0400
Message-ID: <50902BFC.4090309@converseincode.com>
Date: Tue, 30 Oct 2012 15:35:24 -0400
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Helper macros used for replacing the use of VLAIS
References: <1351621520-17768-1-git-send-email-behanw@converseincode.com> <1351621520-17768-2-git-send-email-behanw@converseincode.com> <20121030192021.GA1979@kroah.com>
In-Reply-To: <20121030192021.GA1979@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-10-30 03:20 PM, Greg KH wrote:
> On Tue, Oct 30, 2012 at 02:25:19PM -0400, Behan Webster wrote:
>> The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
>> precludes the use of compilers which don't implement VLAIS (for instance the
>> Clang compiler). This new header file contains macros which can be used to
>> calculate the size and offset of variables in an allocated buffer of memory
>> taking into account alignment issues.
>>
>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>> ---
>>   include/linux/valign.h |   87 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 87 insertions(+)
>>   create mode 100644 include/linux/valign.h
> You sent the same patch here, to two different trees (usb and
> networking).  That's not good, what happens if they both apply them?
Good point. My mistake.

People in both subsystems needed to see the patch which is why I sent them.

What would have been a better approach? And how can I fix this?

Behan

-- 
Behan Webster
behanw@converseincode.com

