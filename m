Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab2IUUVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:21:36 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:52944 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850Ab2IUUVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:21:35 -0400
Date: Fri, 21 Sep 2012 22:21:02 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        sameo@linux.intel.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] x86, pci: sta2x11-fixup clock related patches
Message-ID: <20120921202102.GA9020@mail.gnudd.com>
References: <1348159449-21583-1-git-send-email-ciminaghi@gnudd.com> <20120920191002.GA28087@mail.gnudd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120920191002.GA28087@mail.gnudd.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M >ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 09:10:02PM +0200, Alessandro Rubini wrote:
> > the following two patches are needed for the sta2x11 common clock
> > framework (to be submitted shortly) to deal with the possibility
> > of multiple instances of the connext chip on the same machine.
> 
> Thanks you very much for your clock work, Davide.
>
oh actually I'm having a lot of fun with clocks (devicetree is also quite
interesting), so it's a pleasure to contribute my work.
Thanks for your acks :-)

Davide
