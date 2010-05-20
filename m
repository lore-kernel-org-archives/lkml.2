Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab0ETXIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 19:08:55 -0400
Received: from n6-vm0.bullet.mail.gq1.yahoo.com ([98.137.26.79]:26867 "HELO
	n6-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755008Ab0ETXIw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 19:08:52 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 324075.99034.bm@omp126.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=tt/htSo7sI6mCkQBUAXvPDOnPa2kZAyobLglAse3EdykLwAzpavBEXQWyJMT+qkXq4zksc+357sYDQTMNqhpBKeHHjAV1eKhv7io0r33Gni9Es30PDWHEX5pVKP/gSac+NRidR+2V8qilz0Ps8TnzvqZDY65PDnRG87w+Byq5lM=;
Message-ID: <758575.48890.qm@web180307.mail.gq1.yahoo.com>
X-YMail-OSG: oYbIqMwVM1lxRfXvkGIPLeCQDCIhJndykw_ech2JpjqsoLl
 .aHNUPrU8qEp4gLk.AVRwJxsjkw13jwC7FVE2kOHM2LYOcOMHehrsJ_OTzKx
 IjROf3GlW_0vPxBCLcpDLDT1jh7UBgkWSmB4gGPF.qFWFEJ76auRbDyqGtDn
 Ur39g9IFU4I1EZVOHqCy4AtOBCHFXbNspwIZdjpSAXNGLLHUqmkt4J0.sGZL
 jRAjQYgOcU.r9r9XDsXbWIV_VrIvqbWIJVf83WVhnTzHhPmaj3g1JJuXkZhL
 twLGC4GoXgaoGrA0E1Aw-
X-Mailer: YahooMailClassic/11.0.8 YahooMailWebService/0.8.103.269680
Date: Thu, 20 May 2010 16:08:49 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
To: me@felipebalbi.com
Cc: felipe.balbi@nokia.com, Vladimir Pantelic <pan@nt.tu-darmstadt.de>,
       Matthew Garrett <mjg@redhat.com>,
       "me@felipebalbi.com" <me@felipebalbi.com>,
       "Theodore Ts'o" <tytso@mit.edu>, Brian Swetland <swetland@google.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Geoff Smith <geoffx.smith@intel.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20100520185057.GA25089@gandalf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -0700, David Brownell wrote:
> > Some apps do abuse kernel mechanisms, and whether the
> bug is in the
> > app or that kernel mechanism can be a judgement
> call.  I'd expect to
> 
> hey come on, there's no judgement call for an app polling
> every second
> to check battery status or some other status that doesn't
> change that frequently.

Or something as broken as a non-terminating CPU loop ...


Of course not.  But if there's a kernel mechanism exposed to
userspace which really sucks down power ... either it's done
correctly and the problem is userspace abusing it, or it's done
wrong so that it's not possible to be used correctly.  There are
some things that just cost power, and that cost can't be escaped.



