Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab1G0WBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:01:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40683 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab1G0WBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 18:01:48 -0400
MIME-Version: 1.0
Date: Wed, 27 Jul 2011 14:56:39 -0700
Message-ID: <CAL0-=Wysn8WcOqhdzuOzZug8e1x-if7VtWUjre9z13nV0doNBw@mail.gmail.com>
Subject: IPSec Questions
From: T C <tccheung1@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have some questions on how ipsec logic works in kernel.  There might be
a difference between when XFRM was introduced and prior.  If possible,
I like to know both scenarios.  If not, at least from XFRM perspective would
be most helpful.

Specifically, I am interested in knowing how does ipsec obtain the initial keys
from IKE exchange (and thus from XFRM) to set up the SA.   Also what happens
during rekeying?  Does the SA have to be terminated first, or somehow it can be
rekey'ed and continue as the same SA?

Function calls and if possible some flow graphs would be greatly appreciated.

Thanks,
Terry
