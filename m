Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081Ab2FEM31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 08:29:27 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:53957 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab2FEM3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:29:10 -0400
MIME-Version: 1.0
In-Reply-To: <4FCDA403.6070801@spin.net.au>
References: <4FCDA403.6070801@spin.net.au>
Date: Tue, 5 Jun 2012 08:29:09 -0400
Message-ID: <CA+5PVA4K51q=A9wA5kEHBzQ-01MrFZ5-uW3Qi4EvhVftk6acwA@mail.gmail.com>
Subject: Re: Powerpc continued support?
From: Josh Boyer <jwboyer@gmail.com>
To: Chris Jones <chrisjones@spin.net.au>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 2:15 AM, Chris Jones <chrisjones@spin.net.au> wrote:
> I am just thinking about Powerpc support in the kernel. Are there any plans
> to remove its support? And if so, how much space would be saved by its
> removal or at least disablement of Powerpc specific modules?

No plans to remove it at all.  It's one of the more active architecture
ports Linux has.  Why on earth would it be removed?

> Is it worth looking into this for a custom kernel?

Sure... whatever floats your boat I guess.

josh
