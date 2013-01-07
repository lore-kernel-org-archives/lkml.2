Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab3AGUPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 15:15:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab3AGUPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 15:15:54 -0500
Date: Mon, 7 Jan 2013 18:15:00 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Alessandro Rubini <rubini@gnudd.com>, federico.vaga@gmail.com,
        m.szyprowski@samsung.com, mchehab@infradead.org, pawel@osciak.com,
        hans.verkuil@cisco.com, giancarlo.asnaghi@st.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com
Subject: Re: [PATCH v3 2/4] videobuf2-dma-streaming: new videobuf2 memory
 allocator
Message-ID: <20130107181500.24c56803@redhat.com>
In-Reply-To: <20130107124050.3fc5031b@lwn.net>
References: <3892735.vLSnhhCRFi@harkonnen>
	<1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
	<1399400.izKZgEHXnP@harkonnen>
	<12929800.xFTBAueAE0@harkonnen>
	<20130106230947.GA17979@mail.gnudd.com>
	<20130107124050.3fc5031b@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 7 Jan 2013 12:40:50 -0700
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Mon, 7 Jan 2013 00:09:47 +0100
> Alessandro Rubini <rubini@gnudd.com> wrote:
> 
> > I don't expect you'll see serious performance differences on the PC. I
> > think ARM users will have better benefits, due to the different cache
> > architecture.  You told me Jon measured meaningful figures on a Marvel
> > CPU.
> 
> It made the difference between 10 frames per second with the CPU running
> flat out and 30fps mostly idle.  I think that probably counts as
> meaningful, yeah...:)

Couldn't this performance difference be due to the usage of GFP_DMA inside
the VB2 code, like Federico's new patch series is proposing?

If not, why are there a so large performance penalty?

Regards,
Mauro
