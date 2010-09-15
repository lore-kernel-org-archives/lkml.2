Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab0IOWeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 18:34:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47063 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab0IOWeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 18:34:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WOZdcqNceKg0uUMZRqD1aXpb8fT1XmwNFSApIneRWCiPZsz4NuPAk+ou5n6yDQ6+lC
         xLdaLcXBkMSBXlyYNsvgdCD7oq7HfLlt8l2hnHT6b6txubQgsgtX7/9Zcy0wYLvtoGi4
         O5O4OFgg8bTNJbkW0gr5yzbGxheDWjbrKYwqU=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=wydMEm4=kEuxLvNMfAWE6kzAKQ4wBHKFfgXGZ@mail.gmail.com>
References: <AANLkTikHM+o_FCgnVzGhs8UtQ_geXFzKNQpGSZiEN7sx@mail.gmail.com>
	<AANLkTimd_sRpOYaurOT0iSbfd0pMZvhxgUcaqbQvSobu@mail.gmail.com>
	<AANLkTimO1UK+WA8Mc3Myi3gWBpD=D7tXDOX104a8NMKW@mail.gmail.com>
	<87mxrjgjre.fsf@deeprootsystems.com>
	<AANLkTi=oSTBhceK+oMKH8r9ybeMo4XYcQ+hYQOTRY94u@mail.gmail.com>
	<AANLkTi=wydMEm4=kEuxLvNMfAWE6kzAKQ4wBHKFfgXGZ@mail.gmail.com>
Date: Thu, 16 Sep 2010 01:34:04 +0300
Message-ID: <AANLkTi=cH+P6v1t2K5SCBY7EV08egqV2j6b0avJomv7u@mail.gmail.com>
Subject: Re: OMAP3 DSP MMU fault + off mode issue
From: Felipe Contreras <felipe.contreras@gmail.com>
To: venki kaps <venkiece2005@gmail.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, omar.ramirez@ti.com,
        h-kanigeri2@ti.com, ameya.palande@nokia.com, fernando.lugo@ti.com,
        x0hebbar@ti.com, ernesto@ti.com, s-anna@ti.com, grgupta@ti.com,
        ivan.gomez@ti.com, ext-andriy.shevchenko@nokia.com, x0095078@ti.com,
        deepak.chitriki@ti.com, nm@ti.com, ext-phil.2.carmody@nokia.com,
        ohad@wizery.com, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 7:03 PM, venki kaps <venkiece2005@gmail.com> wrote:
> In latest kernels (Eg, linux-2.6.36-rc3),The MMU-Fault debugging
> enhancements code is moved under CONFIG_TIDSPBRIDGE_BACKTRACE.

Indeed, I added that configuration in order to avoid that possibly
troublesome code in a production system. I haven't seen it working
properly yet.

-- 
Felipe Contreras
