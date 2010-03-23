Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab0CWXol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:44:41 -0400
Received: from perec.tyrell.hu ([66.197.149.104]:43746 "EHLO perec.tyrell.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab0CWXok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:44:40 -0400
Message-ID: <4BA9525E.9000701@maroy.hu>
Date: Tue, 23 Mar 2010 17:44:30 -0600
From: =?UTF-8?B?w4Frb3MgTWFyw7N5?= <akos@maroy.hu>
Organization: Tyrell Corporation
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: how to debug a kernel that does not power off?
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This might be a lame question, but: how would I debug a kernel that
simply does not power off a machine? When powering off, on the console I
get to the message: [...] Poweroff.

but then, the machine actually does not power off. This is an HP Envy 15
laptop using an intel i7 CPU, and kernel 2.6.32.9.

I tried to read up on all sorts of documentation, but could not get more
debug info out of the kernel :(

any pointers would be welcome..


Akos
