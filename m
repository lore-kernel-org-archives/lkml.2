Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab0KXRAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:00:49 -0500
Received: from adelie.canonical.com ([91.189.90.139]:40933 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab0KXRAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:00:48 -0500
Subject: Re: [PATCH] WMI: Cater for multiple events with same GUID
From: Colin Ian King <colin.king@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101124165735.GA2710@srcf.ucam.org>
References: <1290181202-9439-1-git-send-email-colin.king@canonical.com>
	 <20101124165343.GK2150@srcf.ucam.org> <1290617793.1872.1.camel@lenovo>
	 <20101124165735.GA2710@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 17:00:45 +0000
Message-ID: <1290618045.1872.2.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 16:57 +0000, Matthew Garrett wrote:
> On Wed, Nov 24, 2010 at 04:56:33PM +0000, Colin Ian King wrote:
> > I'm preparing a WMI driver that will use this - I will submit this in
> > the next few days.
> 
> Ok, were you thinking .37 or .38 for that?
> 
.37 if I can get it done soon enough.


