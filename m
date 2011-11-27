Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab1K0KVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 05:21:38 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44419 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752625Ab1K0KVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 05:21:37 -0500
X-Sasl-enc: 9WyfNZOkw66xHIKOatfkwObpF6j8FpptEfC9Zd/igPa2 1322389294
Date: Sat, 26 Nov 2011 20:21:24 -0800
From: Greg KH <greg@kroah.com>
To: Corentin Chary <corentincj@iksaif.net>
Cc: platform-driver-x86@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 13/16] samsung-laptop: make the dmi check less strict
Message-ID: <20111127042124.GD17802@kroah.com>
References: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
 <1322301613-8801-14-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322301613-8801-14-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 11:00:10AM +0100, Corentin Chary wrote:
> This enable the driver for everything that look like
> a laptop and is from vendor "SAMSUNG ELECTRONICS CO., LTD.".
> Note that laptop supported by samsung-q10 seem to have a different
> vendor strict.
> 
> Also remove every log output until we know that we have a SABI interface
> (except if the driver is forced to load, or debug is enabled).
> 
> Keeping a whitelist of laptop with a model granularity is something that can't
> work without close vendor cooperation (and we don't have that).
> 
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

