Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab0LRUKD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 15:10:03 -0500
Received: from elasmtp-junco.atl.sa.earthlink.net ([209.86.89.63]:47248 "EHLO
	elasmtp-junco.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932083Ab0LRUKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 15:10:02 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=CqUEpW9Usg6cgYqHPB3TGD2VQYE2J08F49XYqCkhMVMFt2Pbj7yk1ZBJTOLBkMWO;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4D0D1516.3040404@earthlink.net>
Date: Sat, 18 Dec 2010 15:09:58 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: I915 driver locks up
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79868d4e0ad7bac251f71464752e549c8a350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am using 2.6.35.9-64.fc14.x86_64 running 1.3.9-1.fc14.x86_64
and am having my 945gma lock up in texture decompress according
to intel_gpu_top utility, when trying to play Myst 5.

Any fixes on the horizon?

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



