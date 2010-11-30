Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab0K3Vpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:45:40 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54442 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab0K3Vpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:45:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=W1MU100gwmQ3cgOTIK5XukJxErZVYFAH3OEg9SXNpsq2R0PgMvK/V1c84O2s42NJPz
         3VZxss/3+tnO/yuKhPL659fFRuojgx1NyC3jDd5dWPP9Nf5GZ1CyQ1Tvozl+ah/wanuM
         qcd9fg52HD+i66T8PiJzcWEXoF/EEPyqFnW8Q=
MIME-Version: 1.0
In-Reply-To: <1291153197.4814.11.camel@amalthea>
References: <AANLkTi=ywUP8QUDGqotutccf9E2a1b5U2bKNZDWa3PG3@mail.gmail.com>
	<1291153197.4814.11.camel@amalthea>
Date: Tue, 30 Nov 2010 16:45:37 -0500
Message-ID: <AANLkTindpiARKKEKgxtsA4ft9UYEJz4yz+kFQRpZ195X@mail.gmail.com>
Subject: Re: [alsa-devel] CONFIG_SND_HDA_INTEL regression on 2.6.37-rc3 - no audio
From: Daniel Chen <seven.steps@gmail.com>
To: Tony Vroon <tony@linx.net>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 4:39 PM, Tony Vroon <tony@linx.net> wrote:
> (The only audio regression in 2.6.37 that I'm aware of was Realtek
> ALC269-related and has already been fixed. It left me without volume
> control until -rc3)

A couple others (both AC'97 and HDA) have popped up since 2.6.32, and
they're resolve as they're reported.

Best,
-Dan
