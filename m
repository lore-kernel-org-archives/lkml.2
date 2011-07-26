Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab1GZInc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 04:43:32 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50073 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1GZInZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 04:43:25 -0400
MIME-Version: 1.0
In-Reply-To: <m1ei1ewsxa.fsf@fess.ebiederm.org>
References: <5f6c52c61003241920i6b3eaaf7k946f67d1a6f9e384@mail.gmail.com>
	<m1r5n7ln0l.fsf@fess.ebiederm.org>
	<CAKdQVUZMC0eaeqev=tAbS2myHJOA1KJt4r8TVMz6=yQeDpUpZQ@mail.gmail.com>
	<CAKdQVUaKea64ROeDo-SLRgQ3sHptyxD2TjKKgK5OmS+28Ee1zw@mail.gmail.com>
	<m1ei1ewsxa.fsf@fess.ebiederm.org>
Date: Tue, 26 Jul 2011 16:43:24 +0800
Message-ID: <CAKdQVUYRoj5xEkq2c1LjrJmy9P2zZqG3PNZkRxCLCzyytQcevg@mail.gmail.com>
Subject: Re: x86_64 virtual memory map
From: Bob Zhang <zhanglinbao@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hayfeng Lee <omycle@gmail.com>, ak@linux.intel.com,
        Bob Zhang <2004.zhang@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

who can answer my first email of questions ?thanks .

Good idea , yes ,yes ,BIOS probes the real physical RAM size ,and
linux kernel will get this by e820 BIOS call(INT 0x15) .we can check
e820 output to judge whether firmware 's problem or not.

 I will grab e820 output information from dmesg .now ,I can't access
that machine , so wait .thanks .
