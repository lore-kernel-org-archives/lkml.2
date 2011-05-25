Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab1EYUoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:44:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:60306 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756296Ab1EYUoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:44:23 -0400
X-Authenticated: #1474915
X-Provags-ID: V01U2FsdGVkX18WOlEXU6MWIiyfJgLaVfPAEbL9cbsW0CNhsR4zIo
	jwY0708nb+xQCF
Message-ID: <4DDD6A23.9030903@gmx.de>
Date: Wed, 25 May 2011 22:44:19 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        Ulrich Keller <uhkeller@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
References: <4DAF6C0B.3070009@gmx.de> <loom.20110511T124036-180@post.gmane.org> <20110512140352.GG11579@random.random> <201105232005.56840.johannes.hirte@fem.tu-ilmenau.de> <20110525160659.GE19505@random.random>
In-Reply-To: <20110525160659.GE19505@random.random>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You and Ulrich both have PREEMPT=y so it may be a preempt
> bug. What about you Thomas, do you have PREEMPT=y too?

Yes, I have CONFIG_PREEMPT=y on both affected machines too.

Thomas

