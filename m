Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab2HNWOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 18:14:37 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48566 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2HNWOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 18:14:35 -0400
X-Originating-IP: 217.70.178.142
X-Originating-IP: 173.246.103.110
Date: Tue, 14 Aug 2012 15:14:29 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Thai Bui <blquythai@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] boot: Put initcall_debug into its own Kconfig option
 DEBUG_INITCALL
Message-ID: <20120814221429.GA4109@jtriplet-mobl1>
References: <1344891431-30869-1-git-send-email-blquythai@gmail.com>
 <20120813212151.GA15429@phenom.dumpdata.com>
 <CAKkTMC5SP6LgWbhtkU_HCBUAfArGuHXtp4mcwi2tFTjZOwVQbA@mail.gmail.com>
 <5029823A.9020207@xenotime.net>
 <20120814011826.GA2255@leaf>
 <502AB14C.6090406@xenotime.net>
 <20120814205537.GA2879@jtriplet-mobl1>
 <502AC233.5020105@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502AC233.5020105@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 02:25:07PM -0700, Randy Dunlap wrote:
> Surely.  I have no gross objection to this specific patch.

OK.  Thanks!

PATCHv2 will hide the option behind EMBEDDED and make it default to y.

- Josh Triplett
