Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab1BCBW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 20:22:58 -0500
Received: from smtp-out.google.com ([74.125.121.67]:61272 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab1BCBW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 20:22:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YwgzggO1fTMUIZfwifNHYzPVtG+zPmswLfEUz3Iqg6o7CkmVVypgc+Gb5IGkCHznPt
         E0w+twO1Ntb1LYx6dJyQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTikrV3fQ-qsOANG5X7zes1wxbO9mX1eev3xB_OzF@mail.gmail.com>
References: <AANLkTikrV3fQ-qsOANG5X7zes1wxbO9mX1eev3xB_OzF@mail.gmail.com>
From: Tipp Moseley <tipp@google.com>
Date: Wed, 2 Feb 2011 17:22:33 -0800
Message-ID: <AANLkTikAphF5zMoeiiXA5b9zcMpq+DCw1tbZoqsRwOFe@mail.gmail.com>
Subject: Fwd: perf report/stat and symbolic event names
To: acme@redhat.com
Cc: perfmon2-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Arnaldo, Stephane suggested I mail you for this feature request to
the perf tool.
When I collect a "raw" event using perf record, perf report's output
is pretty useless.  E.g.:
# Events: 833  raw 0x3d500a0
So when I collect multiple events, I have to refer to the command line
used to collect the profile and line up the event flags to figure out
what I was collecting.  With multiple collection runs, this can become
quite confusing.
The perf.data file doesn't seem to have the symbolic name of the event present.
Do you think it would be reasonable to add a field to the profile to
include the symbolic description of the event as it was given on the
command line (e.g., "RS_UOPS_DISPATCHED:u:i:e:c=3")?
Tipp
