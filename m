Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1DKPQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 11:16:04 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44467 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1DKPQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 11:16:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gKVHvW+QJUSaAglcaHqFpdXpolvpNhUdQUyLrkxvWuH8MRnZUET1FlAHVB/zfBw3WD
         UPdWiz6qI1lLybowmeo5eAnL6rvhEKKPgDKqwFUPi4X4azn+S1T/b44cdrQcMl1ffTqE
         8feEegpGWHQVjejB08K1Pz5rQqEOISQO6chwg=
Message-ID: <4DA31B20.1010205@gmail.com>
Date: Mon, 11 Apr 2011 08:15:44 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Jiri Kosina <jkosina@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: manual merge of the trivial tree with the wireless
 tree
References: <20110411132844.fa651c08.sfr@canb.auug.org.au>
In-Reply-To: <20110411132844.fa651c08.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2011 08:28 PM, Stephen Rothwell wrote:
> Hi Jiri,
>
> Today's linux-next merge of the trivial tree got a conflict in
> drivers/net/wireless/ath/ath9k/phy.h between commit a9b6b2569cf1
> ("ath9k_hw: turn a few big macros into functions") from the wireless tree
> and commit 6eab04a87677 ("treewide: remove extra semicolons") from the
> trivial tree.
>
> The former commit removed the code that the latter changed, so I did that.

yikes... I dont like seeing that.. what can I do to help with this?

Justin P. Mattock
