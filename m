Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165Ab2AQBMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 20:12:12 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45211 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766Ab2AQBML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 20:12:11 -0500
X-Sasl-enc: 0G8LkEU+um5N+163DQ95sD8UwvV0Q8NKTh8HRVKNNyTb 1326762730
Date: Mon, 16 Jan 2012 17:12:05 -0800
From: Greg KH <greg@kroah.com>
To: Preston Fick <pffick@gmail.com>
Cc: preston.fick@silabs.com, linux-usb-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.2.0] cp210x: Bug fix for CP2104 baudrate usage,
 Bugzilla #42586
Message-ID: <20120117011205.GA8936@kroah.com>
References: <CAJbtUMGDUixS1h7Ct+TmkK+-9r3TPZaa54QkRvh8fNpm5CwjTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJbtUMGDUixS1h7Ct+TmkK+-9r3TPZaa54QkRvh8fNpm5CwjTA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 06:14:09PM -0600, Preston Fick wrote:
> The main reason I'd like my patch applied is to get involved in the
> process of helping to maintain this driver. I'm trying to adhere
> closely to the patch and reporting standards with an easy fix like
> this so I can understand the process and add more fixes and features
> in the future.

Ok, I'll queue this and Johan's patches up in a week or so, thanks for
fixing this one, it looks correct now.

greg k-h
