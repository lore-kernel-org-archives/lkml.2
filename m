Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab2BOJMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:12:55 -0500
Received: from shawmail.shawcable.com ([64.59.128.220]:6500 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab2BOJMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:12:52 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=v9IqiuXHtmwFiI2YJqo6dQmw2SJvdDx3gP8sCAnt4Ec= c=1 sm=1
 a=G7xqIsxYtDwA:10 a=x_C_tvmhfqcA:10 a=uOwpdFIVRigA:10 a=BLceEmwcHowA:10
 a=8nJEP1OIZ-IA:10 a=hlIRttenAlqNJ4J6tNYqEQ==:17 a=rnWUfXiLAAAA:8
 a=4GlxJGVLAAAA:8 a=2heuXqm4tgKQnkD_COEA:9 a=wPNLvfGTeEIA:10
 a=9Lz4i5PVcMQA:10 a=m2ENbNmgp_QA:10 a=KC3hKcOb50uROX-f:21
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
X-IronPort-AV: E=Sophos;i="4.73,422,1325487600"; 
   d="scan'208";a="502586070"
X-reinject: true
Message-ID: <4F3B74CD.3010403@openoctave.org>
Date: Wed, 15 Feb 2012 02:03:09 -0700
From: Christopher Cherrett <ccherrett@openoctave.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Juce plugins cause realtime kernel lockup
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We are putting native VST plugin support into our DAW Open Octave Midi

When you use a plugin compiled with juce the whole system hangs. This 
only happens with the RT kernel and not the standard PREEMPT kernel.

There is a thread of several users running into this issue.

http://www.rawmaterialsoftware.com/viewtopic.php?f=5&t=8507

Can you help shed some light? I am told that it is possibly a problem 
with the RT kernel.

The system will not shut down but needs a hard boot, spewing hpet errors.

Thanks!

-- 
Christopher Cherrett
ccherrett@openoctave.org
http://www.openoctave.org

