Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab0LCLQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 06:16:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932347Ab0LCLQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 06:16:45 -0500
Date: Fri, 3 Dec 2010 12:16:38 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: kdump broken on 2.6.37-rc4
Message-ID: <20101203111623.GA2741@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my T-60 laptop, i686 system with 2.6.37-rc4 kernel,
"echo c > /proc/sysrq-trigger" just hung the system. Kdump
works on 2.6.36. Is this known issue? If not, what info
I should provide to solve it (I think the easiest way
to solve the problem would be bisect) ?

Stanislaw
