Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab1CaEzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 00:55:10 -0400
Received: from linux-sh.org ([111.68.239.195]:58581 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab1CaEzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 00:55:08 -0400
Date: Thu, 31 Mar 2011 13:54:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Peter Jones <pjones@redhat.com>, linux-fbdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, zeus@gnu.org
Subject: Re: [PATCH] efifb: support AMD Radeon HD 6490
Message-ID: <20110331045409.GB15486@linux-sh.org>
References: <1301530342.2140.2.camel@offworld>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301530342.2140.2.camel@offworld>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 09:12:22PM -0300, Davidlohr Bueso wrote:
> This patch enables the framebuffer for the AMD Radeon 6490 found in the new MacBook Pro 8,2 generation.
> The framebuffer's base is located at 0x90010000, the method for obtaining it was found in the same way mentioned in https://patchwork.kernel.org/patch/91704/
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> Signed-off-by: Jonathan Gonzalez <zeus@gnu.org>

Applied, thanks.
