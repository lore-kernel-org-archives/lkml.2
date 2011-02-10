Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1BJIHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 03:07:12 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35776 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab1BJIHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 03:07:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=A0iWfAhIg6EyI7zcSAkLUownUvMPZya245kNHvpffJgwtni43UDnuLNxXtCgOFpfN1
         leChC/xzrp68FMNmrWZRICqGRB92r42CjrhoBdpqlou+MP2Y6VsO4/KwaGwTYuubcROe
         lp+1U2NqI9d6zDNJrhOzlzM71vVcBOwVOUQSo=
MIME-Version: 1.0
Date: Thu, 10 Feb 2011 00:07:10 -0800
Message-ID: <AANLkTikfKduOsPPtxm0uO5qDUxZG1iZN-hnpqUdvPkZJ@mail.gmail.com>
Subject: cpu voltage scaling
From: mihn leigh <mihnsk@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to change voltage and frequency seperately in intel i7 core(nehalem).
With cpu-freq, i can change frequency, but cannot change voltage AFAIK.

I tried PHC "http://www.linux-phc.org", but change of voltage leads to
frequency as well.
Also, i tried to change IA32_PERF_CTL(MSR) register, but i also failed
to fix the frequency while changing the voltage.

Now, i have a plan to dig into PPC table, but i'm not sure if it's
possible or not.
Could you guys give me some infomartion how to change voltage seperately?

Thanks,
mihn
