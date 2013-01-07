Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3AGTkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 14:40:53 -0500
Received: from tex.lwn.net ([70.33.254.29]:58352 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab3AGTkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 14:40:52 -0500
Date: Mon, 7 Jan 2013 12:40:50 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: federico.vaga@gmail.com, mchehab@redhat.com, m.szyprowski@samsung.com,
        mchehab@infradead.org, pawel@osciak.com, hans.verkuil@cisco.com,
        giancarlo.asnaghi@st.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, s.nawrocki@samsung.com
Subject: Re: [PATCH v3 2/4] videobuf2-dma-streaming: new videobuf2 memory
 allocator
Message-ID: <20130107124050.3fc5031b@lwn.net>
In-Reply-To: <20130106230947.GA17979@mail.gnudd.com>
References: <3892735.vLSnhhCRFi@harkonnen>
	<1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
	<1399400.izKZgEHXnP@harkonnen>
	<12929800.xFTBAueAE0@harkonnen>
	<20130106230947.GA17979@mail.gnudd.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2013 00:09:47 +0100
Alessandro Rubini <rubini@gnudd.com> wrote:

> I don't expect you'll see serious performance differences on the PC. I
> think ARM users will have better benefits, due to the different cache
> architecture.  You told me Jon measured meaningful figures on a Marvel
> CPU.

It made the difference between 10 frames per second with the CPU running
flat out and 30fps mostly idle.  I think that probably counts as
meaningful, yeah...:)

jon
