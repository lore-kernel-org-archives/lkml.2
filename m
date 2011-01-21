Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab1AUUq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 15:46:29 -0500
Received: from kroah.org ([198.145.64.141]:38341 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab1AUUq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 15:46:27 -0500
Date: Fri, 21 Jan 2011 12:38:15 -0800
From: Greg KH <greg@kroah.com>
To: Naveen Kumar G <naveen.gaddipati@stericsson.com>
Cc: linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH 2/2] staging: synaptics: Implement error hamdling for
 rmi4 touch regulator
Message-ID: <20110121203815.GA25099@kroah.com>
References: <1295605236-3031-1-git-send-email-naveen.gaddipati@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295605236-3031-1-git-send-email-naveen.gaddipati@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 03:50:36PM +0530, Naveen Kumar G wrote:
> From: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> 
> Implement the error handling for regulator in synaptics
> rmi4 touch screen
> 
> Signed-off-by: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>

This patch has some fuzz and doesn't apply correctly.  Care to rediff it
and resend it?

thanks,

greg k-h
