Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579Ab2EYUSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:18:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43254 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab2EYUSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:18:34 -0400
Message-ID: <4FBFE90A.5090407@zytor.com>
Date: Fri, 25 May 2012 13:18:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Newbury <steve@snewbury.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org> <1337754877-19759-3-git-send-email-yinghai@kernel.org> <CA+55aFzd1BWqidt95qZLc1x_YU=WeGS=mKUOMvO_3omOhc_5VA@mail.gmail.com> <CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com> <CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com> <20120525043651.GA1391@google.com> <CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com> <CAE9FiQW0rm2_sKdSCWs3TfatJB9yHwvmvt9_vBYMtOq_YBbmfw@mail.gmail.com> <20120525193716.GA8817@google.com>
In-Reply-To: <20120525193716.GA8817@google.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 12:37 PM, Bjorn Helgaas wrote:
> 
> That's goofy.  You're proposing to make only x86_64 and x86-PAE try to put
> 64-bit BARs above 4GB.  Why should this be specific to x86?  I acknowledge
> that there's risk in doing this, but if it's a good idea for x86_64, it
> should also be a good idea for other 64-bit architectures.
> 

And so it is (assuming, of course, that we can address that memory.)

	-hpa

