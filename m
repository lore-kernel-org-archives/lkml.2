Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab0JLF5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 01:57:14 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39931 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab0JLF5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 01:57:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CB3F89A.2010005@s5r6.in-berlin.de>
Date: Tue, 12 Oct 2010 07:56:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: linux-next: manual merge of the net tree with the  tree
References: <20101012111716.0c54b093.sfr@canb.auug.org.au> <20101012145135.9697fe21.sfr@canb.auug.org.au>
In-Reply-To: <20101012145135.9697fe21.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> On Tue, 12 Oct 2010 11:17:16 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Today's linux-next merge of the net tree got a conflict in
>> drivers/ieee1394/eth1394.c between commit
>> 66fa12c571d35e3cd62574c65f1785a460105397 ("ieee1394: remove the old IEEE
>> 1394 driver stack") from the  tree and commit
>                                ^
> I meant to say "the ieee1394 tree".

(I should have put the ieee1394 removal into -next much earlier.  OTOH the
conflicting commit is from August 17 already...)

Would it be useful if I rebase this small ieee1394 removal branch of mine onto
net?
-- 
Stefan Richter
-=====-==-=- =-=- -==--
http://arcgraph.de/sr/
