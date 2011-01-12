Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab1ALRnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 12:43:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47675 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1ALRnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 12:43:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=GtXueAanyw+sACJQr25iI0GV/CvF4CxBjz0QgoWcNLp0J72gJxvf/WCsD7UoEyTxZ2
         UFclAfVCNLSt+R52ViwhGM9bh7bLItqOlsnQnbK0pE/XZKpOw9VzcWy82crL7Q8muwbE
         2LhPqpdNS34kdORYQKuwe0T5JGIvlajxzfP4M=
Message-ID: <4D2DE824.10205@gmail.com>
Date: Wed, 12 Jan 2011 12:43:00 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux Kernel Developers <linux-kernel@vger.kernel.org>
CC: Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: TCPCT API update for 2.6.37
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent flurry of messages related to TCPCT, I devoted a nice
snowy Saturday afternoon to updating the socket option code.  Linux is
rather behind on TCPCT implementation, so this will help with future
software compatibility.

Currently, any userland programs written to RFC-to-be-6013 will not
interoperate with Linux 2.6.33 and beyond.  I've made these patches
for 2.6.37 -- they'll also need to be ported to earlier releases.

I'm not on this list, so anybody with comments should CC me.  Thanks.
