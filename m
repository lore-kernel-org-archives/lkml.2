Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab2JOP0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 11:26:50 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:53114 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2JOP0t convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 15 Oct 2012 11:26:49 -0400
Message-Id: <507C475502000078000A17AA@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 15 Oct 2012 16:26:45 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Michal Marek" <mmarek@suse.cz>
Cc: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
Subject: commit fe04ddf7c2910362f3817c8156e41cbd6c0ee35d reverts
 unrelated changes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

is there any reason why that commit reverts two other changes
(to arch/x86/Makefile and scripts/Makefile.fwinst) without any
mention of the reason for this in the description?

Also, Greg, didn't this get merged into stable a little too quickly?

Thanks, Jan

