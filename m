Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1EXGpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:45:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51577 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab1EXGpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:45:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lHVch+lsc9yVPZp1vONzofNDUSF4fO5Ke4r9JrJNn3lQeeXCvmOXKLaZtyBO5eM3Wg
         qOtguq3DT2G4lKWF2a8gE8h+nX8fnueIlOPhqrovQo47khCugkvYUM3Wb1+5NOP8VuP8
         y9dBs/+IoctVe0K6A4xbNz7Rtg5Aw8NFiBcNU=
Message-ID: <4DDB540F.6060603@gmail.com>
Date: Mon, 23 May 2011 23:45:35 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, joe@perches.com,
        greearb@candelatech.com
Subject: Re: [PATCH v2]net:8021q:vlan.c Fix pr_info to just give the vlan
 fullname and version.
References: <1306215647-2857-1-git-send-email-justinmattock@gmail.com> <20110524.022144.2121988243667976554.davem@davemloft.net>
In-Reply-To: <20110524.022144.2121988243667976554.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2011 11:21 PM, David Miller wrote:
> From: "Justin P. Mattock"<justinmattock@gmail.com>
> Date: Mon, 23 May 2011 22:40:47 -0700
>
>> The below patch removes vlan_buggyright and vlan_copyright from vlan_proto_init,
>> so that it prints out just the fullname of vlan and the version number.
>
> Come on Justin, you're making various strings now completely
> unreferenced.  Don't just leave them there, remove them.
>

ah.. I did think, but was warry about removing them. resent with the 
references removed(hopefully).

Justin P. Mattock
