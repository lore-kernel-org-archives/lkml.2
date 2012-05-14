Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab2ENUAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:00:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50249 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab2ENUAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:00:23 -0400
Message-ID: <1337025618.8218.41.camel@fourier>
Subject: Re: [PATCH] dell-laptop: rfkill blacklist Dell XPS 13z, 15z
From: Kamal Mostafa <kamal@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mario Limonciello <mario_limonciello@dell.com>
Date: Mon, 14 May 2012 13:00:18 -0700
In-Reply-To: <20120514193718.GA6438@srcf.ucam.org>
References: <1337023652-11661-1-git-send-email-kamal@canonical.com>
	 <20120514193718.GA6438@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 20:37 +0100, Matthew Garrett wrote:
> On Mon, May 14, 2012 at 12:27:32PM -0700, Kamal Mostafa wrote:
> > From: Mario Limonciello <mario_limonciello@dell.com>
> > 
> > On Dell XPS 13z (L321X) and 15z (L502X), switching off Bluetooth also
> > disables wifi due to improper improper BIOS interaction with dell-laptop.
> > Add those models to the rfkill blacklist.
> 
> What does "Improper BIOS interaction" mean? What's the proper BIOS 
> interaction?
> 

Just that disabling bluetooth also incorrectly disables wifi on those
models (the same as happens for other Dell models in the table?), but
they behave properly (their disable behaviors are no longer linked) once
added to the dell_blacklist table.

I'll resubmit the patch, with perhaps better wording, and since I've
been advised that the model name "XPS 15z" should actually be just "XPS
15".

 -Kamal

