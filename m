Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab0CVCq4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 22:46:56 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:10629 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab0CVCqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 22:46:55 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Questions about SMP bootup control
Date: Mon, 22 Mar 2010 10:46:32 +0800
Message-ID: <2234BBB33B4B2048B28E3B3ACFC9795C01B53251@CNBEEXC007.nsn-intra.net>
In-Reply-To: <1269225435.8599.70.camel@pasglop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Questions about SMP bootup control
Thread-Index: AcrJaLuy9BJ5rzGqTTiK/wIfAP+fqgAAC35A
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org> <1269155601-18247-7-git-send-email-yinghai@kernel.org> <1269225435.8599.70.camel@pasglop>
From: "Zhu, Yijun (NSN - CN/Beijing)" <yijun.zhu@nsn.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
X-OriginalArrivalTime: 22 Mar 2010 02:46:52.0622 (UTC) FILETIME=[ED76DEE0:01CAC969]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All:

I want to do some modification on the SMP architecture.

Purpose:
Only the first CPU is running the linux OS, while others do some private
services processing.

My solution:
In the end of the start_secondary() function, I try to schedu the slave
cpu to call my private endless loop instead of cpu_idle();

Result:
The system can NOT up, there is no interactive cli.

Question:
Is there some wrong with my modification or I go to the wrong way?

Thank you very much.
