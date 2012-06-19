Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab2FSN3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 09:29:25 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:57275 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab2FSN3Y convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:1:1>);
	Tue, 19 Jun 2012 09:29:24 -0400
Message-Id: <4FE09AFC020000780008A9DC@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 19 Jun 2012 14:30:04 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <kay@vrfy.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: printk behavioral regression
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay,

running 3.5-rc3 on a SLE11 SP1 system, early boot messages (apart
from the very first one) end up in /var/log/messages rather than
/var/log/boot.msg. I didn't dig deep enough yet to figure out what
is causing this, and would hope that you (having contributed most
of the changes between 3.4 and 3.5-rc3) might have an idea.

Thanks for any hint,
Jan

