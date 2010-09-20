Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab0ITNla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 09:41:30 -0400
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:35700
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755692Ab0ITNl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 09:41:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=N8h1/MXgO2SZIjh+0fjJ1W5q9FKPz4dD4HThYgmEKlqY9OzCteATdmtWPavhbPHl;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4C976487.5040300@earthlink.net>
Date: Mon, 20 Sep 2010 09:41:27 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: ipsec encryption
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79a41dad4c0835d4c99cd06128fbd08855350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello List,

I have been searching for a diagram that shows where in the packet flow thru
the kernel that ipsec encryption/encapsulation takes place in relation to the
netfilter flow diagrams. None of the netfilter diagrams I have found indicate
where ipsec encryption/decryption takes place.

Thanks in advance,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



