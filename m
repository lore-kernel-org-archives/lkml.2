Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab2C0LVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 07:21:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39033 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab2C0LVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 07:21:09 -0400
Date: Tue, 27 Mar 2012 12:21:05 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] samsung-laptop: unregister ACPI video module for some
 well known laptops
Message-ID: <20120327112105.GA2845@srcf.ucam.org>
References: <20120320163002.GB6811@srcf.ucam.org>
 <1332421699-5315-1-git-send-email-corentincj@iksaif.net>
 <CAHR064hc4AdFUeoO8Szg0FG6CwLK+xauGn9VMJntWV1Gik=ACQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHR064hc4AdFUeoO8Szg0FG6CwLK+xauGn9VMJntWV1Gik=ACQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 11:11:18AM +0200, Corentin Chary wrote:
> Matthew, is this one ok ? I really hope this patch can go in 3.4 so we
> don't introduce a regression for old laptops.

Yes, I've got this now.

Thanks,
-- 
Matthew Garrett | mjg59@srcf.ucam.org
