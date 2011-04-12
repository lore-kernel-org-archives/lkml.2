Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab1DLUPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:15:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739Ab1DLUPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:15:52 -0400
Message-ID: <4DA4B2EA.5050303@redhat.com>
Date: Tue, 12 Apr 2011 16:15:38 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>
Subject: Re: [PATCH]: mce: don't print "human readable" message for corrected
 errors
References: <20110412174405.26867.65604.sendpatchset@prarit.bos.redhat.com> <20110412185842.GB9891@liondog.tnic> <987664A83D2D224EAE907B061CE93D5301A9629BD5@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301A9629BD5@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> We are also setting TAINT_MACHINE_CHECK for corrected errors - perhaps
> this made sense when systems were small and machine checks were rare and
> scary.  But I think we need to start working with the reality that
> corrected errors are normal events.
>
>   

It still makes sense for small lt 1TB systems, IMO.  But ... maybe a
flag of some sort is necessary to stop the TAINTing for systems larger
than that.  The CEs may point to something going wrong on a system.  CEs
in theory become UCEs eventually, right?

>From a OS point of view, we would like to know that there is flaky HW on
the system.

/me knows this is going to turn into a PFA discussion in 4 ... 3 ... 2
....   ;)

P.

> -Tony
>   
