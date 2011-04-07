Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab1DGUoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 16:44:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49284 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797Ab1DGUn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 16:43:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fv5aPKZdCCfZUJgwHU7qzQws4ezW5e9JJBKBPR6pi8mh7YhODyFTb8rR9zzcjb3NDZ
         ugjUpFDVxuQ5eoL3sEvB05rTtXwlq4QLXH3D2nleYeuXbru3WXsDgyosu8iXmgSkYNiM
         RLVcjL5lZonXBJzWtir/i96igEewoigf/WDsY=
Message-ID: <4D9E2207.10809@gmail.com>
Date: Thu, 07 Apr 2011 13:43:51 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        socketcan-core@lists.berlios.de, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [RFC 1/6]Fix typo "recieve" in various parts of the kernel.
References: <1302192567-842-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1104072230440.1538@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1104072230440.1538@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2011 01:32 PM, Jesper Juhl wrote:
> On Thu, 7 Apr 2011, Justin P. Mattock wrote:
>
>> The patch below fixes some typos "recieve" in various parts of the kernel.
>> Note: these below are in actual code rather than comments(excpet for r852.c which
>> has a code fix, and comment).
>> compile tested as best as I can...
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>> CC: linux-input@vger.kernel.org
>> CC: linux-arm-kernel@lists.infradead.org
>> CC: linux-mtd@lists.infradead.org
>> CC: netdev@vger.kernel.org
>> CC: socketcan-core@lists.berlios.de
>> CC: linux-scsi@vger.kernel.org
>> CC: linux-usb@vger.kernel.org
>
> Looks good to me.
>
> Reviewed-by: Jesper Juhl<jj@chaosbits.net>
>

cool.. thanks for reveiwing!

Justin P. Mattock
