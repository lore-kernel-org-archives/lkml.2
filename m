Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab0FITwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:52:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54712 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab0FITwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:52:32 -0400
Date: Wed, 9 Jun 2010 20:52:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ortwin =?iso-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org
Subject: Re: freeze when strace X
Message-ID: <20100609195228.GA27088@srcf.ucam.org>
References: <4C0FDF9F.9070000@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C0FDF9F.9070000@odi.ch>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 08:38:23PM +0200, Ortwin Glück wrote:
> I can freeze the system reproducibly in 2.6.35-rc2 and 2.6.34 when I simply try
> to strace a running X. strace-ing other processes is no problem. Nothing in the
> logs unfortunately. This happens with nosmp and with smp. I would like to track
> this down. What should I be looking for? Apart from trying to bisect it, which I
> will try.

Just to make sure, you're not trying to strace X from within X, are you?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
