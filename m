Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab1CHCKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 21:10:41 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58143 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab1CHCKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 21:10:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] mm: skip zombie in OOM-killer
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110308105458.7EA2.A69D9226@jp.fujitsu.com>
References: <alpine.DEB.2.00.1103061400170.23737@chino.kir.corp.google.com> <20110308105458.7EA2.A69D9226@jp.fujitsu.com>
Message-Id: <20110308111001.7EA8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Mar 2011 11:10:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't understand you think which task is eligible and unnecessary.
> But, Look! Andrey is not talking about zombie process case. But, this v2
> patch have factored out other tasks too. This IS the problem. No need
             ^^^^^^^^
             filter.

I need to rest.


