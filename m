Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab0IFJMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 05:12:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab0IFJMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 05:12:44 -0400
Message-ID: <4C84B088.5050003@redhat.com>
Date: Mon, 06 Sep 2010 12:12:40 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: disabling group leader perf_event
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  If I read the code correctly, disabling a group leader perf_event will 
disable the entire group.

Is this correct?

If so, how can I disable just the event itself?  Can I allocate a dummy 
invent for the group leader so I can enable and disable each perf_event 
in the group individually?

-- 
error compiling committee.c: too many arguments to function

