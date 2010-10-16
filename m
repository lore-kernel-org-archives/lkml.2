Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab0JPHYi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:24:38 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:50694 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab0JPHYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:24:37 -0400
Date: Sat, 16 Oct 2010 08:24:35 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Don Zickus <dzickus@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        mingo@elte.hu, fweisbec@gmail.com, robert.richter@amd.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] arch generic way to trigger unknown NMIs
In-Reply-To: <20101010202357.GA28938@lenovo>
Message-ID: <alpine.LFD.2.00.1010160822250.15889@eddie.linux-mips.org>
References: <20101007030807.GA4076@redhat.com> <20101007072641.GE5010@basil.fritz.box> <20101007140112.GN10663@redhat.com> <alpine.LFD.2.00.1010072342170.15889@eddie.linux-mips.org> <20101010202357.GA28938@lenovo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Oct 2010, Cyrill Gorcunov wrote:

> We have send_IPI_self which can't be used for NMI delivery mode (ie with
> self shortland) but still can be used as say (didn't test)

 So what's stopping send_IPI_self() from being used for an NMI?  Can't the 
function be updated/fixed to support these if there's a need?

  Maciej
