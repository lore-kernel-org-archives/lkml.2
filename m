Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab1DKPYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 11:24:34 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:55880 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab1DKPYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 11:24:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=L1XsRdI6TLFBnDcLpYe7eulTiJ5bScNtbpdMuvrnK5NkjxOaO6W0JjnjPJp1du3mSz
         7Qo/rvFwMeZbs9jOxg25KUPvWrelIrmCKDd02bjDAugD1GUIO+oVC/Dm964FUNbaaA/R
         kAvWRT56IOT+drsBaxgCMnPEr9mObiu530074=
Message-ID: <4DA31D28.20906@gmail.com>
Date: Mon, 11 Apr 2011 08:24:24 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: manual merge of the trivial tree with the wireless
 tree
References: <20110411132844.fa651c08.sfr@canb.auug.org.au> <4DA31B20.1010205@gmail.com> <alpine.LNX.2.00.1104111716590.12035@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1104111716590.12035@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2011 08:17 AM, Jiri Kosina wrote:
> On Mon, 11 Apr 2011, Justin P. Mattock wrote:
>
>>> Today's linux-next merge of the trivial tree got a conflict in
>>> drivers/net/wireless/ath/ath9k/phy.h between commit a9b6b2569cf1
>>> ("ath9k_hw: turn a few big macros into functions") from the wireless tree
>>> and commit 6eab04a87677 ("treewide: remove extra semicolons") from the
>>> trivial tree.
>>>
>>> The former commit removed the code that the latter changed, so I did that.
>>
>> yikes... I dont like seeing that.. what can I do to help with this?
>
> No need for you to do anything. I'll resolve the conflict.
>

o.k.!

Justin P. Mattock
