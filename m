Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab2DBNAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 09:00:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52992 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab2DBNAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 09:00:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120324083943.1db775e5@lwn.net>
References: <CAP=ejEsGRF2i0Rr_W8cNZgJ8W+PHzHNpVRsBtMTmfEiVro+Kjw@mail.gmail.com>
	<20120324083943.1db775e5@lwn.net>
Date: Mon, 2 Apr 2012 18:30:53 +0530
Message-ID: <CAP=ejEtXnztqm1H2Aspuagc9b=fUtoChg-4Xs1wptkpjuUutzg@mail.gmail.com>
Subject: Re: Query on Linux process sheduling
From: "B.Vinai Kumar" <vinaibangala2001@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

Thanks for reply.

As you said all the real time process are scheduled in the 50ms, when
I set the period time value and run time value to "950000" us.

What is the risk when we change the default values?

When I completely disabled this feature. (by writing "-1" to run time
value), then also I see all the real time process are always
scheduled.

Thanks,
Vinai.
