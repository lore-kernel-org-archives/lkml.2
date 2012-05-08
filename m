Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab2EHDQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 23:16:04 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:42036 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab2EHDP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 23:15:59 -0400
Message-ID: <1336446956.2097.16.camel@shrek.rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both: draft
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 13:15:56 +1000
In-Reply-To: <201205072214.13912.rjw@sisk.pl>
References: <1336379825.2097.5.camel@shrek.rexursive.com>
	 <201205072214.13912.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 22:14 +0200, Rafael J. Wysocki wrote:
> Looks reasonable at first sight.

OK, thanks for having a look! I'll check to see whether memory for
hibernation is been released properly and then I may submit this for
real. BTW, the patch actually worked on my ThinkPad T510. The miracles
never stop. :-)

Just to be sure - I should prepare a patch against your linux-next
branch, correct? This patch was against mainline, which is still
somewhat behind.

-- 
Bojan

