Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab2LRCax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 21:30:53 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:48093 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab2LRCaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 21:30:52 -0500
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2012 21:30:52 EST
Message-ID: <50CFD41F.70103@gmail.com>
Date: Mon, 17 Dec 2012 18:25:35 -0800
From: Artem Germanov <ru.artem@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: get socket backlog limit on unix domain socket
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any way to get socket backlog limit on unix domain socket? In 
FreeBSD there is getsockopt() with SO_LISTENQLIMIT,
but not in Linux. There is getsockopt() with TCP_INFO that returns such 
info for tcp socket, but returns 'Not implemented' for UDS.
What is the right place to implement such functionality? Is porting 
SO_LISTENQLIMIT to linux a good idea?

WBR, Artem Germanov.
