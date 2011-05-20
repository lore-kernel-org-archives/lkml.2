Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab1ETCIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 22:08:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:50771 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab1ETCIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 22:08:37 -0400
Subject: Re: [bg-linux] [PATCH 5/7] [RFC] force 32-byte aligned kmallocs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kazutomo Yoshii <kazutomo.yoshii@gmail.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, bg-linux@lists.anl-external.org
In-Reply-To: <4DD5C49E.4050103@gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	 <1305753895-24845-5-git-send-email-ericvh@gmail.com>
	 <1305851769.7481.90.camel@pasglop>  <4DD5C49E.4050103@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 12:08:21 +1000
Message-ID: <1305857301.7481.121.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 20:32 -0500, Kazutomo Yoshii wrote:
> 
> Actually DMA sends invalidate requests to the snoop unit(L2 level).
> BGP SoC is a bit different from other 4xx base. 

Well, some other 44x also have a snooping L2 (more or less), but L1 is
usually the problem.

Cheers,
Ben.


