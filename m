Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab1IAUqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 16:46:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47543 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab1IAUqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 16:46:38 -0400
Message-ID: <4E5FEF28.60406@gmail.com>
Date: Thu, 01 Sep 2011 22:46:32 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: tim.c.chen@linux.intel.com
CC: "David S. Miller" <davem@davemloft.net>,
        ML netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [next] unix stream crashes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my box 100% crashes when booting. It's both in unix socket recv and send 
paths. I've reverted 0856a30409 (Scm: Remove unnecessary pid & 
credential references in Unix socket's send and receive path) and it 
seems to help.

The oops:
http://www.fi.muni.cz/~xslaby/sklad/panics/af_unix_crash.png

regards,
-- 
js
