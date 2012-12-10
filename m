Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab2LJFzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 00:55:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab2LJFzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 00:55:22 -0500
Date: Mon, 10 Dec 2012 11:24:43 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjur@brendeland.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjurbren@gmail.com,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Subject: Re: [PATCHv8 0/3]virtio_console: Add rproc_serial driver
Message-ID: <20121210055443.GB17187@amit.redhat.com>
References: <1351587113-2566-1-git-send-email-sjur@brendeland.net>
 <20121108090624.GB31962@amit.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121108090624.GB31962@amit.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) 08 Nov 2012 [10:06:24], Amit Shah wrote:
> On (Tue) 30 Oct 2012 [09:51:50], Sjur Brændeland wrote:
> > From: Sjur Brændeland <sjur.brandeland@stericsson.com>
> > 
> > This patch-set introduces a new virtio type "rproc_serial" for communicating
> > with remote processors over shared memory. The driver depends on the
> > the remoteproc framework. As preparation for introducing "rproc_serial"
> > I've done a refactoring of the transmit buffer handling.
> 
> Thanks, Sjur.
> 
> Please pick the virtio spec from
> 
> https://github.com/rustyrussell/virtio-spec
> 
> and update the spec with info for remote-proc.

Hi Sjur,

I didn't hear back from you on this..

		Amit
