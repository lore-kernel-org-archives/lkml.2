Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab2FFVls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:41:48 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47940 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab2FFVlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:41:46 -0400
MIME-Version: 1.0
In-Reply-To: <1339017911.21725.20.camel@x61.thuisdomein>
References: <1339017911.21725.20.camel@x61.thuisdomein>
Date: Wed, 6 Jun 2012 23:41:45 +0200
Message-ID: <CACRpkdaaEnBkWR27wjFeBnouJR0NpAH5DXQT1tZE0Nc94PNe+A@mail.gmail.com>
Subject: Re: [PATCH] mfd/ab5500: delete ab5500-core.h
From: Linus Walleij <linus.walleij@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 11:25 PM, Paul Bolle <pebolle@tiscali.nl> wrote:

> Commit 72fb92200d6c31b9982c06784e4bcff2f5b7d8b6 ("mfd/ab5500: delete
> AB5500 support") deleted all files that used ab5500-core.h. That file
> apparently was simply overlooked. Delete it too.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Sam, please pick this for the -rc kernels.

Yours,
Linus Walleij
