Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab1K0KV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 05:21:57 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55264 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752625Ab1K0KVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 05:21:55 -0500
X-Sasl-enc: 7vR5stgg+iP77ZfzjZBkOvZOK7jFqmK7CWXwYclMVG46 1322389313
Date: Sat, 26 Nov 2011 20:22:10 -0800
From: Greg KH <greg@kroah.com>
To: Corentin Chary <corentincj@iksaif.net>
Cc: platform-driver-x86@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 14/16] samsung-laptop: dump model and version
 informations
Message-ID: <20111127042210.GE17802@kroah.com>
References: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
 <1322301613-8801-15-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322301613-8801-15-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 11:00:11AM +0100, Corentin Chary wrote:
> We still need to figure out exactly what each of different fields
> represent, but they contain at least model and version informations.
> 
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
