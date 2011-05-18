Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab1ERA0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 20:26:45 -0400
Received: from dell.nexicom.net ([216.168.96.13]:47275 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512Ab1ERA0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 20:26:43 -0400
Message-ID: <4DD31264.4070704@lockie.ca>
Date: Tue, 17 May 2011 20:27:16 -0400
From: James <bjlockie@lockie.ca>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110512 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: help to bisect
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How do I build v2.6.36 so I can test it mark it good so I can bisect?

Here is what I want to do:
$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.git
$ cd linux-2.6.37.y
$ git bisect start
$ git bisect good v2.6.36
$ git bisect bad v2.6.37.6

Do I do "git checkout v2.6.36"?

