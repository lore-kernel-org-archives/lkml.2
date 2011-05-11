Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1EKTgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:36:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44231 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab1EKTgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:36:22 -0400
Date: Wed, 11 May 2011 20:36:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: naveen yadav <yad.naveen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm <linux-mm@kvack.org>,
        linux newbie <linux.newbie79@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: [ARM]crash on 2.6.35.11
Message-ID: <20110511193602.GK5315@n2100.arm.linux.org.uk>
References: <BANLkTimLd-qY-OeKqnf2EoTfvAHWQZVchw@mail.gmail.com> <BANLkTi=oZ0Mr33rL=QNmzDuaKLNezoKBXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=oZ0Mr33rL=QNmzDuaKLNezoKBXg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 03:46:55PM +0530, naveen yadav wrote:
> Attaching test case
> 
> Dear all,
> 
> We are running linux kernel 2.6.35.11 on Cortex a-8. when I run a
> simple program expect to give oom.
>  But it crash with following crash log

You need to include the memory layout information - eg, the boot log,
and /proc/iomem.  Also are you using sparsemem?  If so, how is it
configured?
