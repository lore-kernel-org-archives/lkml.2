Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440Ab2EOPjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:39:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49696 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965264Ab2EOPjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:39:41 -0400
Date: Tue, 15 May 2012 08:39:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: edwin_rong@realsil.com.cn
Cc: gregkh@suse.de, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: update TODO files for rts5139 & rts_pstor
Message-ID: <20120515153931.GA25240@kroah.com>
References: <1337049392-8544-1-git-send-email-edwin_rong@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337049392-8544-1-git-send-email-edwin_rong@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 10:36:32AM +0800, edwin_rong@realsil.com.cn wrote:
> From: edwin_rong <edwin_rong@realsil.com.cn>
> 
> Recently we find that many warm-hearted people are helping improving the
> coding style and something else of driver rts5139 & rts_pstor, which will
> be replaced with one new refactored uniform Realtek cardreader driver in
> the future, update the TODO file to inform people not to do modifications
> to both of the drivers any more to avoid wasting their time and energy.

Is there anything that you can point people to today for this "new
driver"?  Given that there is no other driver at this point in time, I
don't blame people for fixing up this one to work properly.  So until we
see a new driver, I don't feel comfortable asking people to stop working
here, do you?

thanks,

greg k-h
