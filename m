Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab2GBMhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 08:37:06 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:57047 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2GBMhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 08:37:05 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au5PAC6V8U9V5qg+PGdsb2JhbABFihWsRxkBAQEBHhkNJ4IYAQEEATocIwULCAMOOBQlChqIGQm7KxSQYWADlTOFZox/
X-IronPort-AV: E=Sophos;i="4.77,511,1336341600"; 
   d="scan'208";a="369795178"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 2 Jul 2012 14:37:15 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: synaptics - print firmware ID and board
 number at init
Message-ID: <20120702123715.GA1898@polaris.bitmath.org>
References: <1340859117-19654-1-git-send-email-djkurtz@chromium.org>
 <20120702072740.GA624@polaris.bitmath.org>
 <CAGS+omCy9g8Q6gJhcgMatr+jWPkAzHge6sZOR8HOM92+-xBhXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS+omCy9g8Q6gJhcgMatr+jWPkAzHge6sZOR8HOM92+-xBhXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Is there a specific usecase for this, except the nice-to-have?
> 
> Use cases (these are all very real use cases, that we use today, they
> are not hypothetical):
>   * To include firmware and hardware versions in user feedback reports.
>   * Used by factory tests to ensure systems are being built and
> deployed correctly.
>   * Lastly, these are also precursor patches for a larger set that
> adds firmware update capability.  A userspace firmware update script
> can use these APIs to determine which file to load and/or whether such
> a load is necessary.

Thanks. Future firmware update patches is the prime reason for the
sysfs interface, IOW.

> If there is a standard non-driver-specific way of achieving these use
> cases, I'd be happy to modify the implementation to adopt that
> standard.  From what I've seen, however, it looks like most drivers
> have their own ad hoc way of exposing device/vendor specific
> properties.

Precisely. If there is no standard, it is quite alright to try to come
up with one. Otherwise we might as well leave all firmware-related
code in userspace.

Thanks,
Henrik
