Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab1CaPXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:23:09 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:56817 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753091Ab1CaPXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:23:07 -0400
Date: Thu, 31 Mar 2011 18:23:02 +0300
From: Felipe Balbi <balbi@ti.com>
To: Ramya Desai <ramya.desai@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: GPL License Query on a Plain Linux Application
Message-ID: <20110331152301.GL5465@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <AANLkTi=aT2-ugOhDdSuh241PF-Sz-fFL1BkCUahoq0+o@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=aT2-ugOhDdSuh241PF-Sz-fFL1BkCUahoq0+o@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

On Thu, Mar 31, 2011 at 08:49:34PM +0530, Ramya Desai wrote:
> I have written an application where it uses plain system calls like
> open, read, write etc. and runs in the user space. My question here,
> is this application comes under GPL?
> 
> Any ideas / hints would be appreciated.

you might want to ask FSF.org for that. But bottomline is that if you're
not linking with any GPL code, you don't have to be GPL if you don't
want to, although there are many benefits of doing so (IMHO).

-- 
balbi
