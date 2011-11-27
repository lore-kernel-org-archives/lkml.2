Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1K0KVD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 05:21:03 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60034 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752625Ab1K0KVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 05:21:00 -0500
X-Sasl-enc: /zKFBEofVT8UGdnpkOG68wXwhXUWNzgyBbeKj26P1/Qk 1322389257
Date: Sat, 26 Nov 2011 20:21:11 -0800
From: Greg KH <greg@kroah.com>
To: Corentin Chary <corentincj@iksaif.net>
Cc: platform-driver-x86@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 12/16] samsung-laptop: add true rfkill support for
 swsmi
Message-ID: <20111127042111.GC17802@kroah.com>
References: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
 <1322301613-8801-13-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322301613-8801-13-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 11:00:09AM +0100, Corentin Chary wrote:
> The wireless status get and get commands seems to use one
> byte per device. First byte is for wlan and third is for bluetooh,
> we will have to find what the other are for.
> 
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
