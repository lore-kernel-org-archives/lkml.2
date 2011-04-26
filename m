Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016Ab1DZWpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:45:52 -0400
Received: from kroah.org ([198.145.64.141]:36281 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759000Ab1DZWpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:45:50 -0400
Date: Tue, 26 Apr 2011 15:43:19 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: Re: [PATCH 17/25] Staging: hv: Make event_dpc a global variable
Message-ID: <20110426224319.GA31974@kroah.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-17-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303834842-5022-17-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 09:20:34AM -0700, K. Y. Srinivasan wrote:
> In preparation for getting rid of struct hv_bus, Make event_dpc a
> global variable.

It's "static", one for the whole driver, not global.

thanks,

greg k-h
