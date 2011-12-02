Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1LBIjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 03:39:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:55812 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab1LBIjb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 03:39:31 -0500
Message-ID: <1322815142.4699.67.camel@twins>
Subject: Re: [PATCH] jump_label: jump_label for boot options.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jason Baron <jbaron@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        rostedt@goodmis.org
Date: Fri, 02 Dec 2011 09:39:02 +0100
In-Reply-To: <20111202092837.58e11827.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20111201154036.GA2443@redhat.com>
	 <20111202092837.58e11827.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 09:28 +0900, KAMEZAWA Hiroyuki wrote:
> Most of distro users will not turn off it... 

Most distros carry a patch that changes the default to off.
