Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab1JJLmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:42:25 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40102 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab1JJLmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:42:24 -0400
MIME-Version: 1.0
In-Reply-To: <4E92AF9D.8060702@gmail.com>
References: <20111006190526.GA13883@redhat.com>
	<4E92AF9D.8060702@gmail.com>
Date: Mon, 10 Oct 2011 07:42:23 -0400
Message-ID: <CA+5PVA6FhU1Xv80OqrcybRN=Txqg2vpJWgcRmCcZjRyBEEz3Ng@mail.gmail.com>
Subject: Re: RFC: virtualbox tainting.
From: Josh Boyer <jwboyer@gmail.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 4:41 AM, Maarten Lankhorst
<m.b.lankhorst@gmail.com> wrote:
> Patch vbox' kernel modules instead?
> Seems to mark it as crap, all you have to do is add this to the driver source:
> MODULE_INFO(staging, "Y");

The distributions can't patch the user's vbox modules.  Unless they're
patched in the upstream vbox source, this really isn't going to work.

josh
