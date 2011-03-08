Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab1CHWgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 17:36:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34975 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab1CHWgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 17:36:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=sE5RpD2ovI0wOtiQr70pqfL7BFzRrvvUSi5UdjeJ1eUG5L0aGgYC3kb8ieshlRDzuy
         jv/CTHZjO5RtEOw695l63OwkJ3zFY8P05eP9dYG2p0cyhInGeWcoSi33jGaV7KPnSdbC
         76717On+GoUAFaJN18EboUErPyhYgyXueUhtQ=
Date: Wed, 9 Mar 2011 01:36:20 +0300
From: Dan Carpenter <error27@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: Re: [PATCH 06/15] staging: xgifb: delete bIntegratedMMEnabled
Message-ID: <20110308223620.GD3416@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	arnaud.patard@rtp-net.org
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
 <1299615380-22922-7-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299615380-22922-7-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 10:16:11PM +0200, Aaro Koskinen wrote:
> bIntegratedMMEnabled is always true, so the field and checks can be
> eliminated.
> 

What about for the chips that came before the XG40?  Are we dropping
support for them?

regards,
dan carpenter

