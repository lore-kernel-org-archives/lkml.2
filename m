Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab2AROVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:21:32 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:57981 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab2AROVb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 18 Jan 2012 09:21:31 -0500
Message-Id: <4F16E377020000780006D78D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 18 Jan 2012 14:21:27 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        <luca@luca-barbieri.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] ix86: atomic64 adjustments
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pair of patches first fixes the asm() constraints in the C wrappers, and
then does a few improvements to the actual assembly implementation.

1: adjust asm constraints in atomic64 wrappers
2: atomic64 assembly improvements

Signed-off-by: Jan Beulich <jbeulich@suse.com>

