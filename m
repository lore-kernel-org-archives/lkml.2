Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab1AEPWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:22:53 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:42178 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1AEPWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:22:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LuIgPqr5UOWOa1obAN4dSBXEpYObCrvjZ2IlTiDmdKnr2ZHvwb3uz56OKPAcUCsFj5
         1GdMVinQasqNG14aeuZrJjD4kSTrDqn/kApVoGg3iYEV61FEvHf5lHoETxYx9BOY4/kg
         iGIUEsbDGdxazs/llaYoWc4Dk4ubwcyTiLhCk=
Message-ID: <4D248CC5.1050903@gmail.com>
Date: Wed, 05 Jan 2011 07:22:45 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the trivial tree with the net tree
References: <20110104142229.7aa6b99f.sfr@canb.auug.org.au> <alpine.LNX.2.00.1101051550240.26685@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1101051550240.26685@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 06:51 AM, Jiri Kosina wrote:
> On Tue, 4 Jan 2011, Stephen Rothwell wrote:
>
>> Today's linux-next merge of the trivial tree got a conflict in
>> drivers/net/wireless/iwlwifi/iwl-core.c between commit
>> 81baf6ec9c190ae128748cf2a026bff5cb811b70 ("iwlwifi: Legacy isr only used
>> by legacy devices") from the net tree and commit
>> 62e45c14fb9a978dca6c7a5dc8372cc8ea2f42c8 ("wireless: comment typo fix
>> diable ->  disable") from the trivial tree.
>>
>> The former moves the code modified by the latter to
>> drivers/net/wireless/iwlwifi/iwl-legacy.c. I didn't bother refixing the
>> typo there.
>
> I will definitely be merging to Linus trivial queue later than davem will,
> so I'll be resolving this. Thanks,
>


yeah, I saw this, but was not sure how to reply due to not really 
knowing what happened(looking at the patch these are just in comments,
as opposed to the other patch(7) that actually changes code. keep in 
mind im not sure if it was moved forward due to me having to send out 
another version due to changes(haven't gotten around due to external 
things that need to be taken care of))..

Justin P. Mattock
