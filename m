Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab0EZMBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:01:52 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36895 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab0EZMBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:01:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wfqDogbFbo8CwHbHgvmhtmJZtLKr59WNBeQBvrvTJmZ48ZTTrvsjzznX77YBZI0w91
         xNVHiCUYELb9RhfXvjFTewAYxhFazid4bDWm56AE1+xRpjtmQ79IzvbgeZ2j9t7wfmd5
         Obos3yXsbeJ8/4qTMvFSx1DmT/uc2LsbT7gqA=
MIME-Version: 1.0
In-Reply-To: <20100526133721.602633b2@schatten.dmk.lab>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<201005242049.18920.rjw@sisk.pl>
	<87wrusvrqe.fsf@deeprootsystems.com>
	<201005250138.16293.rjw@sisk.pl>
	<1274863655.5882.4875.camel@twins>
	<AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	<1274867106.5882.5090.camel@twins>
	<20100526120242.5c9b73ad@schatten.dmk.lab>
	<AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	<20100526133721.602633b2@schatten.dmk.lab>
Date: Wed, 26 May 2010 14:01:49 +0200
Message-ID: <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Vitaly Wool <vitalywool@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 1:37 PM, Florian Mickler <florian@mickler.org> wrote:

> This is not "protection". This is functioning properly in a real world
> scenario. Why would the user change the kernel, if the device would be
> buggy after that? (Except maybe he is a geek)

Hmm... Why would the user continue to use the program if it slows down
his device and sucks the battery as a vampire (Except maybe he's a
moron)? ;)

~Vitaly
