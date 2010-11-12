Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab0KLLXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:23:17 -0500
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:47439 "EHLO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab0KLLXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:23:16 -0500
Message-ID: <4CDD23A1.4000707@ge.com>
Date: Fri, 12 Nov 2010 11:23:13 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        "Emilio G. Cota" <cota@braap.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/17] Series short description
References: <20101028175615.GA2367@kroah.com> <20101112111359.11631.84086.stgit@ES-BJ21R4J>
In-Reply-To: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Nov 2010 11:23:14.0514 (UTC) FILETIME=[FF2FAB20:01CB825B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/11/10 11:13, Martyn Welch wrote:
> The following series implements...
> 

Grr. Stacked GIT decided to send the cover before I'd finished writing
it! What I meant to say is:

Hi Greg,

Here's the series of patches from Emilio I have been through and Acked.

Sorry for not sending this sooner, bad health kept me from work. I have
promised to work through the remaining patches for Emilio, however the
absence from work and work commitments means this is going to take a
little longer than I had hoped (sorry Emilio). It is on my "todo" list.

I have applied minor edits to some of the patches to remove checkpatch
warnings, stacked git has the habit of correcting chunk offsets (which
may occur when re-ordering patches etc.), but I believe the others are
as sent by Emilio (with the addition of my ack).

Martyn

-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
