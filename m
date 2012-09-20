Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab2ITT01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 15:26:27 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:55631 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab2ITT00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 15:26:26 -0400
Date: Thu, 20 Sep 2012 21:10:02 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: ciminaghi@gnudd.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        sameo@linux.intel.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org, ciminaghi@gnudd.com
Subject: Re: [PATCH 0/2] x86, pci: sta2x11-fixup clock related patches
Message-ID: <20120920191002.GA28087@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <1348159449-21583-1-git-send-email-ciminaghi@gnudd.com>
References: <1348159449-21583-1-git-send-email-ciminaghi@gnudd.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the following two patches are needed for the sta2x11 common clock
> framework (to be submitted shortly) to deal with the possibility
> of multiple instances of the connext chip on the same machine.

Thanks you very much for your clock work, Davide.

For both: Acked-by: Alessandro Rubini <rubini@gnudd.com>

/alessandro
