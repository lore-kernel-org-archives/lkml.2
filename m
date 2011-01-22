Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750803Ab1AVFFK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 00:05:10 -0500
Received: from smtp-out.google.com ([74.125.121.67]:45739 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1AVFFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 00:05:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:x-system-of-record;
	b=ksM4Li28USe85SQFlRn695+gVSkTirrkqUQKLUJPC0oHuRHdJCUb2zgV7IiRsjmN8
	Ro6lu72wYbxieuB4NEE+Q==
Message-Id: <20110122044458.058531078@google.com>
User-Agent: quilt/0.48-1
Date: Fri, 21 Jan 2011 20:44:58 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: [patch 0/5] scheduler fixlets
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A small set of scheduler patches for the CFS side of things.

Mostly buglet fixes with one or two associated clean-ups.  Each patch should
be (modulo any merge fuzz) independent.

Thanks,

- Paul


