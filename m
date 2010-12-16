Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0LPKyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:54:52 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56012 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab0LPKyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:54:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        b=nBqWbvt3jsgYU9/qroOPCGYaYR7camlxiRPLCQqgf83lNmCaMrW5k6pxyHGGTMUTr4
         b4tiDGIg2MzlzKZxGC1nFtbkaGh80fyR6kdPPgAdy0XIE/BWPTgmz9mwKy0z6etWCxe0
         FEeWEOjBWRKtE/ZTvYOi4JSUaNrze/BVUTcbU=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Thu, 16 Dec 2010 11:54:48 +0100
Message-ID: <AANLkTinbhb-_v+8tJBPeoLcDo0mFzwo2EZAy3bnvErFT@mail.gmail.com>
Subject: Re: linux-next: Tree for December 16 (broken iwlwifi)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        John Linville <linville@tuxdriver.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just FYI (didn't look at the code right now, sorry for German output):

[ build.log ]
...
/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none/drivers/net/wireless/iwlwifi/iwl-agn-rs.c:
In function ‘iwl_rs_rate_init’:
/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none/drivers/net/wireless/iwlwifi/iwl-agn-rs.c:2876:8:
error: ‘struct iwl_lq_sta’ has no member named ‘dbg_fixed_rate’
make[8]: *** [drivers/net/wireless/iwlwifi/iwl-agn-rs.o] Fehler 1
make[7]: *** [drivers/net/wireless/iwlwifi] Fehler 2
make[6]: *** [drivers/net/wireless] Fehler 2
make[6]: *** Warte auf noch nicht beendete Prozesse...
...

Regards,
- Sedat -
