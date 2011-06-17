Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab1FQLm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 07:42:29 -0400
Received: from mail.virtall.com ([178.63.195.102]:58254 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524Ab1FQLm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 07:42:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=wpkg.org; h=message-id:date
	:from:mime-version:to:subject:content-type
	:content-transfer-encoding; q=dns; s=default; b=gUQXuPGtuE09WHeh
	eAL+cUoobSCng6u/ZmSwUyRcWnBVNnq2MgSd8IkWI/Xw/weZmmxP6upKyBPFpdD7
	OadmcbfTnjdV5+AGd6VIrWLyg50Zg5jWiS+m1wG7aYaIPGqmWtymduHLOFSLWQQN
	v6EuXOrMhRjTWr+aswbeKnFt3Ww=
Message-ID: <4DFB3DA1.7060603@wpkg.org>
Date: Fri, 17 Jun 2011 13:42:25 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: change kernel logging (console=ttyS0) without reboot?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generally, most production systems don't like to be restarted unnecessarily.

I was wondering if it's possible to change kernel logging without a restart?

Say, I connected a serial cable to the server, but kernel was not booted 
with anything like console=ttyS0,19200 in its command line. So anything 
produced by the kernel will not show up on ttyS0.


Can I still somehow make the kernel to log to ttyS0, without restarting 
it (I can make syslog do it, but let's assume the syslog crashed and I'm 
mostly interested in catching a kernel oops/panic etc.)?



-- 
Tomasz Chmielewski
http://wpkg.org
