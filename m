Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934172Ab2HWSat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:30:49 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57717 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab2HWSaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:30:46 -0400
MIME-Version: 1.0
In-Reply-To: <5036750A.301@gmail.com>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com>
	<201208231814.21168.tweek@tweek.dk>
	<CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com>
	<20120823180839.GR23464@ZenIV.linux.org.uk>
	<CAJ7jCmnX17MLoHe9=bL-A2ja_qyfMw2Pa4x9oOj7TCX6rjCDgQ@mail.gmail.com>
	<5036750A.301@gmail.com>
Date: Thu, 23 Aug 2012 20:30:44 +0200
Message-ID: <CAJ7jCmkbujxcUYjQgS9a3pdHtdLmTukJCzExb4TAxLcZG=UJmg@mail.gmail.com>
Subject: Re: Drop support for x86-32
From: wbrana <wbrana@gmail.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Martin Nybo Andersen <tweek@tweek.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/12, David Daney <ddaney.cavm@gmail.com> wrote:
> Exactly what part of your user-space code requires special handling to
> accommodate the differences between the two 32-bit x86 ABIs?  Please be
> specific.
My code doesn't need special handling, but e.g. compilers, virtual
machines, software which use assembler need special handling.
