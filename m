Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab2BQRwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:52:07 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57855 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab2BQRwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:52:03 -0500
Date: Fri, 17 Feb 2012 17:51:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Sumit Bhattacharya <sumitb@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jon Medhurst <tixy@yxit.co.uk>, Naveen Yadav <yad.naveen@gmail.com>
Subject: Re: [PATCH 3/3] ARM: dma-mapping: fix array out of bound access
Message-ID: <20120217175146.GP27825@n2100.arm.linux.org.uk>
References: <1329494160-26942-1-git-send-email-ajeet.yadav.77@gmail.com> <20120217171915.GO27825@n2100.arm.linux.org.uk> <CAB4K4y65c+UdPMpZNSKKhz3fQO1C6no5SnMAsirQ3LvrAk3gpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB4K4y65c+UdPMpZNSKKhz3fQO1C6no5SnMAsirQ3LvrAk3gpA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 11:06:10PM +0530, Ajeet Yadav wrote:
> ok lets consider case that we are accessing last page of last memory mapped
> region and now analyse the for loop we will hit this case

So, come on.  Where's your analysis?
