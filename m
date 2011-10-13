Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab1JMVos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 17:44:48 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:36673 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab1JMVor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 17:44:47 -0400
Subject: Re: [PATCH v8]: Improve performance of LZO/plain hibernation
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Date: Fri, 14 Oct 2011 08:44:45 +1100
In-Reply-To: <201110132326.02041.rjw@sisk.pl>
References: <1317342456.1959.6.camel@shrek.rexursive.com>
	 <201110062045.48689.rjw@sisk.pl> <2409186928.1003010428@rexursive.com>
	 <201110132326.02041.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318542285.2081.1.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-13 at 23:26 +0200, Rafael J. Wysocki wrote:
> If your system is 64-bit, then the patch below may help.

OK, I may try that on my ThinkPad.

Anyhow, you still getting panics as a direct result of my hibernation
patch?

-- 
Bojan

