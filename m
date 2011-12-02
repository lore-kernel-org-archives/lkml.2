Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab1LBAFC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 19:05:02 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45142 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755789Ab1LBAE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 19:04:58 -0500
X-Sasl-enc: 9sCNGE0C3twHeRrru9QKgKpd2N2vohzdNI9Tx3WZgV63 1322784296
Date: Thu, 1 Dec 2011 16:04:47 -0800
From: Greg KH <greg@kroah.com>
To: Alessandro Rubini <rubini@gnudd.com>, rusty@ozlabs.org
Cc: linux-kernel@vger.kernel.org, siglesia@cern.ch, manohar.vanga@cern.ch,
        dave.martin@linaro.org
Subject: Re: [PATCH V2 1/1] modpost: use table-lookup to build module aliases
Message-ID: <20111202000447.GB6507@kroah.com>
References: <cover.1322781825.git.rubini@gnudd.com>
 <0725e3e50a8a1782c8be6f5df7b6ffcfbae404b0.1322781825.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0725e3e50a8a1782c8be6f5df7b6ffcfbae404b0.1322781825.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 12:45:37AM +0100, Alessandro Rubini wrote:
> The function handle_moddevtable was a huge "else if" thing. This
> patch places the lookup in a table to reduce code and increase data.
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Samuel I. Gonsalvez <siglesia@cern.ch>
> Acked-by: Manohar Vanga <manohar.vanga@cern.ch>
> Cc: Dave Martin <dave.martin@linaro.org>

Rusty, do you want to take this one in your tree, or should I take it
through mine?  Either is fine with me, if you want it to go through
yours, feel free to add:

	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

to it.

thanks,

greg k-h
