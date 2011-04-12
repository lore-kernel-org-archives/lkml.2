Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab1DLKlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 06:41:09 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:35107 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab1DLKlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 06:41:07 -0400
Subject: Re: [PATCH 09/34] x86: Allow to override the ROOT_DEV variable
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Marek <mmarek@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
In-Reply-To: <4DA42213.50400@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
	 <1302015561-21047-10-git-send-email-mmarek@suse.cz>
	 <4D9B3581.6080105@zytor.com> <4D9C1AA0.9030008@suse.cz>
	 <20110411150820.GA22004@sepie.suse.cz>
	 <1302584470.26451.11.camel@x61.thuisdomein>  <4DA42213.50400@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 12:40:24 +0200
Message-ID: <1302604824.2082.4.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 11:57 +0200, Michal Marek wrote:
> That makes sense. Will you send it as a proper patch or should I fold it 
> into my patch?

I suggest you fold it into your patch, so everything is cleaned up in a
single commit.


Paul Bolle

