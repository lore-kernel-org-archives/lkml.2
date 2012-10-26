Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966907Ab2JZXfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 19:35:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:47322 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966820Ab2JZXfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 19:35:11 -0400
Date: Fri, 26 Oct 2012 16:35:09 -0700
From: Greg KH <greg@kroah.com>
To: Richard Retanubun <richardretanubun@ruggedcom.com>
Cc: linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
        Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Tang Nguyen <TangNguyen@ruggedcom.com>, m.grzeschik@pengutronix.de,
        Arvid Brodin <Arvid.Brodin@xdin.com>,
        linux-usb mailing list <linux-usb@vger.kernel.org>,
        bigeasy@linutronix.de
Subject: Re: kmemleak report on isp1763 and sierra MC8705
Message-ID: <20121026233509.GA26646@kroah.com>
References: <508B0743.9040806@ruggedcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508B0743.9040806@ruggedcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 05:57:23PM -0400, Richard Retanubun wrote:
> Hi Guys,
> 
> I am debugging a reported kmemleak involving a sierra wireless MC8705 connected
> through isp1763 on powerpc linux-3.0.22

Does this also happen on 3.6.3?

thanks,

greg k-h
