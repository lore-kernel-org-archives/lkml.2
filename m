Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab2BQMjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 07:39:32 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36236 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab2BQMjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 07:39:31 -0500
Message-ID: <4F3E4A7A.1070708@gmail.com>
Date: Fri, 17 Feb 2012 13:39:22 +0100
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: RE: perf, x86: Disable PEBS on SandyBridge chips
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Peter,

Why is PEBS disabled? If I look at the intel_clovertown_quirks I can see 
why it's disabled for that cpu, but the sandy bridge one lacks any kind 
of clarification or information on why, or how I can learn more.

Cheers,
Maarten
