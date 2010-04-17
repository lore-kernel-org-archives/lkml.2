Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab0DQQCk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 12:02:40 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38557 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab0DQQCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 12:02:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=GQ0W8SNbSZ2QKkPEmOBxz00fOg2kNcgyOrTiWZdJjxMB0gz9heU9yuAy0XTQxuUuvo
         bTHY2N3Cu/UPOUixi5EXfdWaFSgQPbQk30s6193Bk9YsjjrnrA32wFSQe0O6cxofzyEe
         fMepHC4i8VsEcH9fNjq51BKTKTWEI69XirVQo=
Message-ID: <4BC9DB9A.9090605@gmail.com>
Date: Sat, 17 Apr 2010 19:02:34 +0300
From: Oleg Kutkov <elenbert@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Network activity after route changes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
I try to send and receive ethernet packets on very low level in my 
kernel module.
When i change routin table (via route command) my network is freeze for 
~15 seconds and my application can't send and receive any packets.
Is it normal or bug somewhere in my application?
Can i change this behavior of route system, maybe change some timeouts, 
or immediately flush route (rt_flush() ?) table?

Thanks.
