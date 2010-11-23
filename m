Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0KWWsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 17:48:08 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47538 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab0KWWsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 17:48:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject;
        b=hH1ZozDEZ4nDUhFmwLQhSogp8quzoARQ8e/Df0Wj92XmtPRUL87Rl1mLEZqvHb01z9
         en1GsfWG9ks9TCPHn21HVtflGPJ0reMVTihYOs8bMfm2HhuNNzOosMgM7mLS7kqoNb+h
         FE1HaN9WUhOQ7f4iNM27t3wRtop/Hoam8MWrs=
Message-Id: <20101123224601.766827604@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 24 Nov 2010 01:46:01 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: ming.m.lin@intel.com, eranian@google.com, peterz@infradead.org
Subject: [rfc 0/3] perf,x86: p4 pmu series
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, please review, the series is about to bring some p4 event config
bits to userspace, so attention and comments would be appreciated.

Thanks,
Cyrill
