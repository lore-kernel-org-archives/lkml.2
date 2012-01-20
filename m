Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2ATQTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:19:44 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:39746 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab2ATQTk convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 20 Jan 2012 11:19:40 -0500
Message-Id: <4F19A269020000780006E0BA@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 20 Jan 2012 16:20:41 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        <luca@luca-barbieri.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] ix86: atomic64 adjustments
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

