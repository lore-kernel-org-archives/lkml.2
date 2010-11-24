Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab0KXUja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 15:39:30 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:33685 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754587Ab0KXUj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 15:39:29 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+MPlMeKkOMhiIyVOxdjPhtHr+USZT0Lbs0waWnFU
	FjLx4RPKnHDoX+
Subject: Re: mmotm 2010-11-23 + autogroups -> inconsistent lock state
From: Mike Galbraith <efault@gmx.de>
To: Valdis.Kletnieks@vt.edu
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1290630325.4050.12.camel@maggy.simson.net>
References: <201011240045.oAO0jYQ5016010@imap1.linux-foundation.org>
	 <6003.1290574869@localhost>  <1290630325.4050.12.camel@maggy.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 13:39:11 -0700
Message-ID: <1290631151.4050.19.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 13:25 -0700, Mike Galbraith wrote:

> The below should run gripe free.

In <= 2.6.37-rc3 kernel I mean.  The tip version is still explosive.

	-Mike

