Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1IWNaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 09:30:10 -0400
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:40394 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752422Ab1IWNaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 09:30:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=Y4Uu+JIL537+eolBdqHX6H689pgt3W7KVG6hLaThPV1FGvRmN892PLoVXv7yUOVq;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4E7C89DE.8090308@earthlink.net>
Date: Fri, 23 Sep 2011 09:30:06 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Bridging unfriendly
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec798a5fdcae153e77b266abce40e091ad6e350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there some reason Linux bridging won't let the ip address be on
one of the interfaces, like FreeBSD does, instead of the bridge device?

This makes it very difficult or impossible to remotely add the interface
you are remoted in on to a bridge, or is there some sneaky way to
do this without losing your connection?

Thanks,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



