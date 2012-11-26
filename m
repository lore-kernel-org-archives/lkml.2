Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab2KZM2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 07:28:14 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53272 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab2KZM2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 07:28:13 -0500
MIME-Version: 1.0
In-Reply-To: <20121126093528.GF8218@suse.de>
References: <CAJd=RBCzydfXGBPLdkyvKaGZPK9H-pKa1-vk38dnZpeiZM8n3w@mail.gmail.com>
	<20121124130419.GA8218@suse.de>
	<CAJd=RBDm8K3UTzY+RHSLnGz+ckx0eEeK4C_NYAiXoiku_PHwog@mail.gmail.com>
	<20121126093528.GF8218@suse.de>
Date: Mon, 26 Nov 2012 20:28:12 +0800
Message-ID: <CAJd=RBBJ6dP58iLowd439tkvT5EPba=N=8V7p1Gsy8JnrxSbdg@mail.gmail.com>
Subject: Re: [PATCH 1/3] balancenuma: add stats for huge pmd numa faults
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/12, Mel Gorman <mgorman@suse.de> wrote:
> In my mind, the primary use of the counter is to estimate how many MB/sec
> are being copied.

The new counters are dropped as they help you little.

Hillf
