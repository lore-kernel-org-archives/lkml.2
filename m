Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab0E1FmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 01:42:01 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56311 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab0E1FmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 01:42:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=mQeHcBxvqN0jFePkYoBU3dZAylY5qpfesCxs2XgduY3XiC4pZ9HHQA8snmaZqHMMDY
         /q2dwt2F750kaPjMUgoE1MI8gcOn0IT3TH3Jika4Tn3FL9+NLEOEy2cjdPoWZLLbxA0B
         IK4qMfb8BEowk4/M6EPLpqjrCdcQFk8ODdIYs=
Message-ID: <4BFF565C.3080108@gmail.com>
Date: Thu, 27 May 2010 22:36:28 -0700
From: JD <jd1008@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: udevd high cpu hogging in kernel-2.6.34   git8 to git-13
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that since git8, udevd consumes from 50 to 80 percent of cpu.
The main udevd thread is niced to -4, and 6 or more child threads are 
niced -2.

So, I backpedaled to git7, which does not have this "feature" :)

Cheers,

JD

