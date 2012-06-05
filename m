Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934260Ab2FENcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:32:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42228 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934202Ab2FENcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:32:52 -0400
Message-ID: <1338903164.28282.177.camel@twins>
Subject: Re: [PATCH] perf: Fix intel shared extra msr allocation
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org
Date: Tue, 05 Jun 2012 15:32:44 +0200
In-Reply-To: <CABPqkBRF_2LXE-54tLMBnQgLKbKyR9qo+4VohQiOchpqe1pgyw@mail.gmail.com>
References: <1338520856-21020-1-git-send-email-zheng.z.yan@intel.com>
	 <CABPqkBScjC5fJbTc1rYtbtRqOCyJ+7QUbdE32DgMcffBAGJNVw@mail.gmail.com>
	 <CAAM7YAkYgUjwQptYvyeVawzcD5x4c-bTT_=+6AMyUb+-6HoMuQ@mail.gmail.com>
	 <1338891271.28282.155.camel@twins>
	 <CABPqkBSv8CbMzUiRsN2uOF1v6rFTpzhQqNbo7OKe-nzsus0GDg@mail.gmail.com>
	 <1338892071.28282.157.camel@twins>
	 <CABPqkBSqLpa4X-WbR0PkouYvhODT78r3pxWq70=PTj1j=a307Q@mail.gmail.com>
	 <1338898024.28282.160.camel@twins> <1338899999.28282.164.camel@twins>
	 <CABPqkBRCMAnPH3UW0=afMw4-YXgwQ5D-NLMEtnNWde_Tzh3aew@mail.gmail.com>
	 <1338901490.28282.167.camel@twins>
	 <CABPqkBRF_2LXE-54tLMBnQgLKbKyR9qo+4VohQiOchpqe1pgyw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 15:31 +0200, Stephane Eranian wrote:
> Looks nicer, still missing this little piece + is_fake definition and
> setting is allocate_fakecpuc())
> 
Yeah, just send out something more complete -- although only built
tested.

This was just seeing how the intel_try_alt_er() stuff could be done
saner.
