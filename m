Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1BAKxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:53:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59949 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab1BAKxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:53:00 -0500
Subject: Re: [PATCH -v8 0/7] directed yield for Pause Loop Exiting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
In-Reply-To: <20110131164049.0ad68e72@annuminas.surriel.com>
References: <20110131164049.0ad68e72@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 01 Feb 2011 11:53:53 +0100
Message-ID: <1296557633.26581.101.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 16:40 -0500, Rik van Riel wrote:
> 
> v8:
> - some more changes and cleanups suggested by Peter 

Did you, by accident, send out the -v7 patches again? I don't think I've
spotted a difference..
