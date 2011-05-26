Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab1EZUOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:14:38 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:56878 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038Ab1EZUOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:14:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ay4afbLfvhfjV69zpyXoSNKfOw7MiTZamGzzeEKTr9+ihj/NeVrcH2GZaxFRJqEGrZ
         LuBJPcJts9Ny/VqpgMO9Hp9NcBNr9Ekkt03HcYFrZ5QzmRfSZLeK/Hkj7oHxjuOcL2Pr
         xzGxaMoG+NFLt/fE3kN7To4ydPO7McgokdizY=
Message-ID: <4DDEB49D.1070003@gmail.com>
Date: Thu, 26 May 2011 13:14:21 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, joe@perches.com,
        greearb@candelatech.com
Subject: Re: [PATCH v3]net:8021q:vlan.c Fix pr_info to just give the vlan
 fullname and version.
References: <1306219428-11528-1-git-send-email-justinmattock@gmail.com> <20110526.145601.735416831290933990.davem@davemloft.net>
In-Reply-To: <20110526.145601.735416831290933990.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2011 11:56 AM, David Miller wrote:
> From: "Justin P. Mattock"<justinmattock@gmail.com>
> Date: Mon, 23 May 2011 23:43:48 -0700
>
>> The below patch removes vlan_buggyright and vlan_copyright from vlan_proto_init,
>> so that it prints out just the fullname of vlan and the version number.
>>
>> before:
>>
>> [   30.438203] 802.1Q VLAN Support v1.8 Ben Greear<greearb@candelatech.com>
>> [   30.441542] All bugs added by David S. Miller<davem@redhat.com>
>>
>> after:
>>
>> [   31.513910] 802.1Q VLAN Support v1.8
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>
> Applied, thanks Justin.
>

cool..

Justin P. Mattock
