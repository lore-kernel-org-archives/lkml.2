Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966287Ab2CANa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 08:30:27 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39298 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966247Ab2CANa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 08:30:26 -0500
Date: Thu, 1 Mar 2012 13:30:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 1/4] x86: add NO_IRQ macro
Message-ID: <20120301133012.GF7363@n2100.arm.linux.org.uk>
References: <cover.1330607068.git.rubini@gnudd.com> <6bda7538144dce0bf5780df3d0601147dae753b5.1330607068.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bda7538144dce0bf5780df3d0601147dae753b5.1330607068.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 02:28:36PM +0100, Alessandro Rubini wrote:
> This is needed to compile AMBA drivers. Most architectures define
> NO_IRQ as -1, and this does the same for the PC.

No.  We're getting rid of NO_IRQ, and it will be gone from AMBA stuff
probably for 3.5.
